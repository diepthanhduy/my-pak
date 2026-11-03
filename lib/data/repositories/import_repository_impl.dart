import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/clock.dart';
import '../../domain/entities/import_draft.dart';
import '../../domain/entities/import_source_type.dart';
import '../../domain/entities/import_summary.dart';
import '../../domain/repositories/import_repository.dart';
import '../local/app_database.dart';
import '../pdf/pdf_import_reader.dart';
import 'drift_settings_repository.dart';

@LazySingleton(as: ImportRepository, env: [Environment.prod])
class ImportRepositoryImpl implements ImportRepository {
  const ImportRepositoryImpl(this._db, this._reader, this._clock);

  final AppDatabase _db;
  final PdfImportReader _reader;
  final Clock _clock;

  @override
  Future<ImportDraft> parse(String filePath) => _reader.read(filePath);

  @override
  Future<ImportSummary> save(ImportDraft draft) => _db.transaction(() async {
    final dao = _db.importDao;
    final listDate = draft.listDate ?? draft.rows.first.appointmentDate!;
    final batchId = await dao.insertBatch(
      ImportBatchesCompanion.insert(
        date: listDate,
        sourceType: ImportSourceType.pdf,
        sourceFilePath: Value(draft.sourceFilePath),
        expectedCount: Value(draft.expectedCount),
        parsedCount: draft.parsedCount,
        createdAt: _clock.now(),
      ),
    );

    var added = 0;
    var existing = 0;
    final callTaskIds = <int>{};
    for (final row in draft.rows) {
      final phone = row.phone!;
      final date = row.appointmentDate!;
      final address = row.address.trim();
      final patientId = await dao.upsertPatient(
        PatientsCompanion.insert(
          medicalCode: row.medicalCode.trim(),
          name: row.name.trim(),
          dob: Value(row.dob),
          address: Value(address.isEmpty ? null : address),
          phoneNormalized: phone,
        ),
      );
      final callTaskId = phone == draft.clinicPhone
          ? null
          : await dao.findOrCreateCallTask(date, phone);
      if (callTaskId != null) callTaskIds.add(callTaskId);
      final appointmentId = await dao.insertAppointmentIfAbsent(
        AppointmentsCompanion.insert(
          patientId: patientId,
          callTaskId: Value(callTaskId),
          importBatchId: Value(batchId),
          date: date,
          stt: row.stt,
          content: row.content.trim(),
        ),
      );
      appointmentId == null ? existing++ : added++;
    }

    final clinicName = draft.clinicName;
    if (clinicName != null && clinicName.isNotEmpty) {
      await _db.settingsDao.put(SettingsKeys.detectedClinicName, clinicName);
    }
    final clinicPhone = draft.clinicPhone;
    if (clinicPhone != null) {
      await _db.settingsDao.put(SettingsKeys.detectedClinicPhone, clinicPhone);
    }

    return ImportSummary(
      listDate: listDate,
      newAppointments: added,
      existingAppointments: existing,
      callTaskCount: callTaskIds.length,
    );
  });
}
