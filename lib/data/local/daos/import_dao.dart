import 'package:drift/drift.dart';

import '../../../core/utils/date_utils.dart';
import '../app_database.dart';
import '../tables/appointments.dart';
import '../tables/call_tasks.dart';
import '../tables/import_batches.dart';
import '../tables/patients.dart';

part 'import_dao.g.dart';

/// Write primitives for saving an imported list; callers wrap them in a
/// transaction.
@DriftAccessor(tables: [ImportBatches, Patients, CallTasks, Appointments])
class ImportDao extends DatabaseAccessor<AppDatabase> with _$ImportDaoMixin {
  ImportDao(super.attachedDatabase);

  Future<int> insertBatch(ImportBatchesCompanion batch) =>
      into(importBatches).insert(batch);

  /// Inserts [patient], or updates the one with the same medical code.
  /// Returns the patient id.
  Future<int> upsertPatient(PatientsCompanion patient) async {
    final row = await into(patients).insertReturning(
      patient,
      onConflict: DoUpdate((_) => patient, target: [patients.medicalCode]),
    );
    return row.id;
  }

  /// Returns the id of the call task for ([date], [phoneNormalized]),
  /// creating a pending one if needed.
  Future<int> findOrCreateCallTask(
    DateTime date,
    String phoneNormalized,
  ) async {
    final day = dateOnly(date);
    final existing =
        await (select(callTasks)..where(
              (t) =>
                  t.date.equals(day) &
                  t.phoneNormalized.equals(phoneNormalized),
            ))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    return into(callTasks).insert(
      CallTasksCompanion.insert(date: day, phoneNormalized: phoneNormalized),
    );
  }

  /// Inserts [appointment] unless its patient already has one that day.
  /// Returns the new id, or null when it already existed.
  Future<int?> insertAppointmentIfAbsent(
    AppointmentsCompanion appointment,
  ) async {
    final row = await into(appointments).insertReturningOrNull(
      appointment,
      onConflict: DoNothing(
        target: [appointments.patientId, appointments.date],
      ),
    );
    return row?.id;
  }
}
