import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:assistant_pak/domain/entities/import_source_type.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final day = DateTime(2026, 11, 3);

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  group('constraints', () {
    test('patients.medicalCode is unique', () async {
      final patient = PatientsCompanion.insert(
        medicalCode: 'YT000001',
        name: 'Nguyễn Văn A',
        phoneNormalized: '0900000001',
      );
      await db.into(db.patients).insert(patient);

      expect(
        () => db.into(db.patients).insert(patient),
        throwsA(isA<SqliteException>()),
      );
    });

    test('call_tasks (date, phoneNormalized) is unique', () async {
      final task = CallTasksCompanion.insert(
        date: day,
        phoneNormalized: '0900000001',
      );
      await db.into(db.callTasks).insert(task);

      expect(
        () => db.into(db.callTasks).insert(task),
        throwsA(isA<SqliteException>()),
      );
      await db
          .into(db.callTasks)
          .insert(
            CallTasksCompanion.insert(
              date: DateTime(2026, 11, 4),
              phoneNormalized: '0900000001',
            ),
          );
    });

    test('foreign keys are enforced', () async {
      expect(
        () => db
            .into(db.contactAttempts)
            .insert(
              ContactAttemptsCompanion.insert(
                callTaskId: 999,
                channel: ContactChannel.call,
                startedAt: day,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('enums are stored as readable text', () async {
      await db
          .into(db.callTasks)
          .insert(
            CallTasksCompanion.insert(date: day, phoneNormalized: '0900000001'),
          );

      final row = await db
          .customSelect('SELECT status FROM call_tasks')
          .getSingle();
      expect(row.read<String>('status'), 'pending');
    });
  });

  group('ImportDao', () {
    test(
      'upsertPatient updates the patient with the same medical code',
      () async {
        final firstId = await db.importDao.upsertPatient(
          PatientsCompanion.insert(
            medicalCode: 'YT000001',
            name: 'Nguyễn Văn A',
            phoneNormalized: '0900000001',
          ),
        );
        final secondId = await db.importDao.upsertPatient(
          PatientsCompanion.insert(
            medicalCode: 'YT000001',
            name: 'Nguyễn Văn B',
            phoneNormalized: '0900000002',
          ),
        );

        expect(secondId, firstId);
        final patient = await db.select(db.patients).getSingle();
        expect(patient.name, 'Nguyễn Văn B');
        expect(patient.phoneNormalized, '0900000002');
      },
    );

    test(
      'findOrCreateCallTask reuses the task of the same day and phone',
      () async {
        final id = await db.importDao.findOrCreateCallTask(
          DateTime(2026, 11, 3, 14, 30),
          '0900000001',
        );

        expect(await db.importDao.findOrCreateCallTask(day, '0900000001'), id);
        expect(
          await db.importDao.findOrCreateCallTask(day, '0900000002'),
          isNot(id),
        );
        final task = await (db.select(
          db.callTasks,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(task.date, day);
      },
    );

    test(
      'insertAppointmentIfAbsent skips a second appointment the same day',
      () async {
        final patientId = await db.importDao.upsertPatient(
          PatientsCompanion.insert(
            medicalCode: 'YT000001',
            name: 'Nguyễn Văn A',
            phoneNormalized: '0900000001',
          ),
        );
        final batchId = await db.importDao.insertBatch(
          ImportBatchesCompanion.insert(
            date: day,
            sourceType: ImportSourceType.pdf,
            parsedCount: 1,
            createdAt: day,
          ),
        );
        AppointmentsCompanion appointment(String content) =>
            AppointmentsCompanion.insert(
              patientId: patientId,
              importBatchId: Value(batchId),
              date: day,
              stt: 1,
              content: content,
            );

        expect(
          await db.importDao.insertAppointmentIfAbsent(appointment('Lần 1')),
          isNotNull,
        );
        expect(
          await db.importDao.insertAppointmentIfAbsent(appointment('Lần 2')),
          isNull,
        );
        final rows = await db.select(db.appointments).get();
        expect(rows.single.content, 'Lần 1');
      },
    );
  });
}
