import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/data/local/mappers/call_task_mapper.dart';
import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/call_task_fixtures.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final day = DateTime(2026, 11, 3);

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  Future<CallTask> roundTrip(CallTask task) async {
    await db.into(db.callTasks).insert(task.toCompanion());
    for (final patient in task.patients) {
      final patientId = await db.importDao.upsertPatient(
        patient.toPatientCompanion(phoneNormalized: task.phoneNormalized),
      );
      await db
          .into(db.appointments)
          .insert(
            patient.toAppointmentCompanion(
              patientId: patientId,
              callTaskId: task.id,
              date: task.date,
            ),
          );
    }
    final lastContact = task.lastContact;
    if (lastContact != null) {
      await db.contactAttemptDao.insertAttempt(
        lastContact.toCompanion(callTaskId: task.id),
      );
    }
    final rows = await db.callTaskDao.watchByDate(task.date).first;
    return rows.single.toEntity();
  }

  test('call task with patients and last call survives a round trip', () async {
    final task = fakeCallTask(
      id: 7,
      date: day,
      status: CallTaskStatus.retry,
      attemptCount: 2,
      nextRetryAt: DateTime(2026, 11, 3, 15),
      patients: [
        fakePatient(stt: 1, dob: DateTime(2021, 5, 20)),
        fakePatient(stt: 2, name: 'Nguyễn Thị B', content: 'Tái khám hô hấp'),
      ],
      lastContact: ContactSummary(
        channel: ContactChannel.call,
        at: DateTime(2026, 11, 3, 10, 15),
        result: ContactResult.noAnswer,
      ),
    );

    expect(await roundTrip(task), task);
  });

  test(
    'pending task with an SMS as last contact survives a round trip',
    () async {
      final task = fakeCallTask(
        id: 1,
        date: day,
        lastContact: ContactSummary(
          channel: ContactChannel.sms,
          at: DateTime(2026, 11, 3, 9, 5),
        ),
      );

      expect(await roundTrip(task), task);
    },
  );

  test('dates are stored as day only', () async {
    final task = fakeCallTask(date: DateTime(2026, 11, 3, 18, 45));

    final stored = await roundTrip(task);

    expect(stored.date, day);
  });
}
