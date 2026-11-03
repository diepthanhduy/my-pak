import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/data/local/daos/call_task_dao.dart';
import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/stream_recorder.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late StreamRecorder<List<CallTaskDetails>> recorder;
  final day = DateTime(2026, 11, 3);

  setUp(() {
    db = openTestDatabase();
    recorder = StreamRecorder(db.callTaskDao.watchByDate(day));
  });
  tearDown(() async {
    await recorder.cancel();
    await db.close();
  });

  Future<int> insertTask(String phone, {DateTime? date}) => db
      .into(db.callTasks)
      .insert(
        CallTasksCompanion.insert(date: date ?? day, phoneNormalized: phone),
      );

  Future<int> insertAttempt(
    int callTaskId,
    DateTime startedAt, {
    ContactResult? result,
  }) => db.contactAttemptDao.insertAttempt(
    ContactAttemptsCompanion.insert(
      callTaskId: callTaskId,
      channel: ContactChannel.call,
      startedAt: startedAt,
      result: Value(result),
    ),
  );

  test('emits tasks of the day only, re-emitting on insert', () async {
    expect(await recorder.next(), isEmpty);

    await insertTask('0900000009', date: DateTime(2026, 11, 4));
    final taskId = await insertTask('0900000001');

    final tasks = await recorder.nextWhere((tasks) => tasks.isNotEmpty);
    expect(tasks.map((t) => t.task.id), [taskId]);
    expect(tasks.single.appointments, isEmpty);
    expect(tasks.single.latestAttempt, isNull);
  });

  test('re-emits when a task status changes', () async {
    expect(await recorder.next(), isEmpty);
    final taskId = await insertTask('0900000001');
    final pending = await recorder.nextWhere((tasks) => tasks.isNotEmpty);
    expect(pending.single.task.status, CallTaskStatus.pending);

    await (db.update(db.callTasks)..where((t) => t.id.equals(taskId))).write(
      const CallTasksCompanion(
        status: Value(CallTaskStatus.retry),
        attemptCount: Value(1),
      ),
    );

    final task = (await recorder.nextWhere(
      (tasks) => tasks.single.task.status != CallTaskStatus.pending,
    )).single.task;
    expect(task.status, CallTaskStatus.retry);
    expect(task.attemptCount, 1);
  });

  test('groups patients by task ordered by STT', () async {
    final first = await insertTask('0900000001');
    final second = await insertTask('0900000002');
    await insertPatientAppointment(
      db,
      callTaskId: first,
      date: day,
      medicalCode: 'YT000002',
      name: 'Nguyễn Thị B',
      stt: 2,
    );
    await insertPatientAppointment(
      db,
      callTaskId: first,
      date: day,
      medicalCode: 'YT000001',
      stt: 1,
    );
    await insertPatientAppointment(
      db,
      callTaskId: second,
      date: day,
      medicalCode: 'YT000003',
      name: 'Trần Văn C',
      phone: '0900000002',
      stt: 3,
    );

    final tasks = await db.callTaskDao.watchByDate(day).first;

    expect(tasks.map((t) => t.task.id), [first, second]);
    expect(tasks[0].appointments.map((a) => a.appointment.stt), [1, 2]);
    expect(tasks[0].appointments.map((a) => a.patient.medicalCode), [
      'YT000001',
      'YT000002',
    ]);
    expect(tasks[1].appointments.single.patient.name, 'Trần Văn C');
  });

  test('latest attempt has the greatest startedAt, then id', () async {
    final taskId = await insertTask('0900000001');
    final otherTaskId = await insertTask('0900000002');

    await insertAttempt(
      taskId,
      DateTime(2026, 11, 3, 10),
      result: ContactResult.busy,
    );
    // Inserted later but started earlier: not the latest.
    await insertAttempt(
      taskId,
      DateTime(2026, 11, 3, 9),
      result: ContactResult.noAnswer,
    );
    await insertAttempt(otherTaskId, DateTime(2026, 11, 3, 11));

    var tasks = await db.callTaskDao.watchByDate(day).first;
    expect(tasks[0].latestAttempt?.result, ContactResult.busy);
    expect(tasks[1].latestAttempt?.callTaskId, otherTaskId);

    final tieId = await insertAttempt(
      taskId,
      DateTime(2026, 11, 3, 10),
      result: ContactResult.confirmed,
    );

    tasks = await db.callTaskDao.watchByDate(day).first;
    expect(tasks[0].latestAttempt?.id, tieId);
    expect(tasks[0].latestAttempt?.result, ContactResult.confirmed);
  });

  test('re-emits when a contact attempt is added', () async {
    expect(await recorder.next(), isEmpty);
    final taskId = await insertTask('0900000001');
    final before = await recorder.nextWhere((tasks) => tasks.isNotEmpty);
    expect(before.single.latestAttempt, isNull);

    await insertAttempt(taskId, DateTime(2026, 11, 3, 8, 30));

    final after = await recorder.nextWhere(
      (tasks) => tasks.single.latestAttempt != null,
    );
    expect(after.single.latestAttempt?.startedAt, DateTime(2026, 11, 3, 8, 30));
  });

  test('countCallTasks counts every day', () async {
    expect(await db.callTaskDao.countCallTasks(), 0);
    await insertTask('0900000001');
    await insertTask('0900000001', date: DateTime(2026, 11, 4));
    expect(await db.callTaskDao.countCallTasks(), 2);
  });
}
