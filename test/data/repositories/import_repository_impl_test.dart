import 'package:assistant_pak/core/utils/clock.dart';
import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/data/pdf/pdf_import_reader.dart';
import 'package:assistant_pak/data/repositories/drift_settings_repository.dart';
import 'package:assistant_pak/data/repositories/import_repository_impl.dart';
import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/import_fixtures.dart';
import '../../helpers/test_database.dart';

class _MockReader extends Mock implements PdfImportReader {}

class _MockClock extends Mock implements Clock {}

void main() {
  late AppDatabase db;
  late ImportRepositoryImpl repository;
  final day = DateTime(2025, 12, 15);

  setUp(() {
    db = openTestDatabase();
    final clock = _MockClock();
    when(clock.now).thenReturn(DateTime(2025, 12, 14, 8));
    repository = ImportRepositoryImpl(db, _MockReader(), clock);
  });
  tearDown(() => db.close());

  final rows = [
    fakeImportRow(key: 1, name: 'Nguyễn Văn A'),
    fakeImportRow(key: 2, name: 'Nguyễn Thị B'),
    fakeImportRow(key: 3, name: 'Trần Văn C', phoneText: '0900 000 003'),
    fakeImportRow(key: 4, name: 'Lê Thị D', phoneText: '028 0000 0001'),
  ];

  test('groups rows by phone and excludes the clinic phone', () async {
    final summary = await repository.save(
      fakeImportDraft(rows: rows, expectedCount: 4),
    );

    expect(summary.listDate, day);
    expect(summary.newAppointments, 4);
    expect(summary.existingAppointments, 0);
    expect(summary.callTaskCount, 2);

    final tasks = await db.callTaskDao.watchByDate(day).first;
    expect(tasks.map((t) => t.task.phoneNormalized), [
      '0900000001',
      '0900000003',
    ]);
    expect(tasks.first.appointments.map((a) => a.patient.name), [
      'Nguyễn Văn A',
      'Nguyễn Thị B',
    ]);
    final clinicRow = await (db.select(
      db.appointments,
    )..where((a) => a.stt.equals(4))).getSingle();
    expect(clinicRow.callTaskId, isNull);

    final batch = await db.select(db.importBatches).getSingle();
    expect(batch.date, day);
    expect(batch.expectedCount, 4);
    expect(batch.parsedCount, 4);
    expect(batch.sourceFilePath, '/tmp/imports/1.pdf');
  });

  test('re-import of the same day keeps call history and adds only new '
      'patients', () async {
    await repository.save(fakeImportDraft(rows: rows.take(3).toList()));
    final taskId = (await db.callTaskDao.watchByDate(day).first).first.task.id;
    await (db.update(db.callTasks)..where((t) => t.id.equals(taskId))).write(
      const CallTasksCompanion(
        status: Value(CallTaskStatus.retry),
        attemptCount: Value(1),
      ),
    );
    await db.contactAttemptDao.insertAttempt(
      ContactAttemptsCompanion.insert(
        callTaskId: taskId,
        channel: ContactChannel.call,
        startedAt: DateTime(2025, 12, 15, 9),
        result: const Value(ContactResult.noAnswer),
      ),
    );

    final summary = await repository.save(
      fakeImportDraft(
        rows: [
          ...rows.take(3),
          fakeImportRow(key: 5, name: 'Phạm Văn E', phoneText: '0900000001'),
        ],
        sourceFilePath: '/tmp/imports/2.pdf',
      ),
    );

    expect(summary.newAppointments, 1);
    expect(summary.existingAppointments, 3);
    final tasks = await db.callTaskDao.watchByDate(day).first;
    expect(tasks, hasLength(2));
    final first = tasks.firstWhere((t) => t.task.id == taskId);
    expect(first.task.status, CallTaskStatus.retry);
    expect(first.task.attemptCount, 1);
    expect(first.latestAttempt?.result, ContactResult.noAnswer);
    expect(first.appointments, hasLength(3));
    expect(await db.select(db.importBatches).get(), hasLength(2));
  });

  test('stores the clinic info read from the PDF for SMS', () async {
    await repository.save(fakeImportDraft());

    final settings = await DriftSettingsRepository(db).getReminderSettings();

    expect(settings.clinicName, 'Phòng khám ABC');
    expect(settings.clinicPhone, '02800000001');
  });

  test('user clinic settings win over detected ones', () async {
    await db.settingsDao.put(SettingsKeys.clinicName, 'Tên tự nhập');
    await repository.save(fakeImportDraft());

    final settings = await DriftSettingsRepository(db).getReminderSettings();

    expect(settings.clinicName, 'Tên tự nhập');
  });

  test('a failing row rolls the whole import back', () async {
    final draft = fakeImportDraft(rows: rows);
    await db.customStatement('DROP TABLE contact_attempts');
    await db.customStatement('DROP TABLE appointments');

    await expectLater(repository.save(draft), throwsA(anything));

    expect(await db.select(db.importBatches).get(), isEmpty);
    expect(await db.select(db.patients).get(), isEmpty);
  });
}
