import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/data/repositories/drift_call_task_repository.dart';
import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/stream_recorder.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftCallTaskRepository repository;
  final day = DateTime(2026, 11, 3);

  setUp(() {
    db = openTestDatabase();
    repository = DriftCallTaskRepository(db);
  });
  tearDown(() => db.close());

  Future<int> seedTask() async {
    final taskId = await db.importDao.findOrCreateCallTask(day, '0900000001');
    await insertPatientAppointment(
      db,
      callTaskId: taskId,
      date: day,
      medicalCode: 'YT000001',
    );
    return taskId;
  }

  test('watchByDate maps rows to entities for any time of the day', () async {
    final taskId = await seedTask();

    final tasks = await repository
        .watchByDate(DateTime(2026, 11, 3, 16, 20))
        .first;

    expect(tasks.single.id, taskId);
    expect(tasks.single.status, CallTaskStatus.pending);
    expect(tasks.single.patients.single.medicalCode, 'YT000001');
    expect(tasks.single.lastContact, isNull);
  });

  test('recordContactStarted stores an attempt and Home re-emits', () async {
    final taskId = await seedTask();
    final recorder = StreamRecorder(repository.watchByDate(day));
    addTearDown(recorder.cancel);
    expect((await recorder.next()).single.lastContact, isNull);
    final startedAt = DateTime(2026, 11, 3, 9, 30);

    await repository.recordContactStarted(
      callTaskId: taskId,
      channel: ContactChannel.sms,
      startedAt: startedAt,
      smsBody: 'Nhắc lịch',
    );

    final tasks = await recorder.nextWhere(
      (tasks) => tasks.single.lastContact != null,
    );
    expect(
      tasks.single.lastContact,
      ContactSummary(channel: ContactChannel.sms, at: startedAt),
    );
    final attempt = (await db.contactAttemptDao.attemptsForTask(taskId)).single;
    expect(attempt.smsBody, 'Nhắc lịch');
    expect(attempt.source, ContactSource.manual);
    expect(attempt.result, isNull);
  });

  test('recordContactStarted fails for an unknown call task', () async {
    expect(
      () => repository.recordContactStarted(
        callTaskId: 42,
        channel: ContactChannel.call,
        startedAt: day,
      ),
      throwsA(isA<SqliteException>()),
    );
  });
}
