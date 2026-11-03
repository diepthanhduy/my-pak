import 'package:drift/drift.dart';

import '../../../core/utils/date_utils.dart';
import '../app_database.dart';
import '../tables/appointments.dart';
import '../tables/call_tasks.dart';
import '../tables/contact_attempts.dart';
import '../tables/patients.dart';

part 'call_task_dao.g.dart';

/// An appointment of a call task joined with its patient.
typedef AppointmentWithPatient = ({
  AppointmentRow appointment,
  PatientRow patient,
});

/// A call task with its appointments and its latest contact attempt.
final class CallTaskDetails {
  const CallTaskDetails({
    required this.task,
    required this.appointments,
    this.latestAttempt,
  });

  final CallTaskRow task;

  /// Ordered by STT.
  final List<AppointmentWithPatient> appointments;
  final ContactAttemptRow? latestAttempt;
}

@DriftAccessor(tables: [CallTasks, Appointments, Patients, ContactAttempts])
class CallTaskDao extends DatabaseAccessor<AppDatabase>
    with _$CallTaskDaoMixin {
  CallTaskDao(super.attachedDatabase);

  late final _latestAttempt = alias(contactAttempts, 'latest_attempt');

  /// Emits the call tasks of [day] now and whenever a task, appointment,
  /// patient or contact attempt changes.
  ///
  /// The latest attempt is the one with the greatest `startedAt`, then id.
  Stream<List<CallTaskDetails>> watchByDate(DateTime day) {
    final candidate = alias(contactAttempts, 'candidate_attempt');
    final latestAttemptId = subqueryExpression<int>(
      selectOnly(candidate)
        ..addColumns([candidate.id])
        ..where(candidate.callTaskId.equalsExp(callTasks.id))
        ..orderBy([
          OrderingTerm.desc(candidate.startedAt),
          OrderingTerm.desc(candidate.id),
        ])
        ..limit(1),
    );
    final query =
        select(callTasks).join([
            leftOuterJoin(
              appointments,
              appointments.callTaskId.equalsExp(callTasks.id),
            ),
            leftOuterJoin(
              patients,
              patients.id.equalsExp(appointments.patientId),
            ),
            leftOuterJoin(
              _latestAttempt,
              _latestAttempt.id.equalsExp(latestAttemptId),
            ),
          ])
          ..where(callTasks.date.equals(dateOnly(day)))
          ..orderBy([
            OrderingTerm.asc(callTasks.id),
            OrderingTerm.asc(appointments.stt),
          ]);
    return query.watch().map(_groupByTask);
  }

  Future<int> countCallTasks() async {
    final count = callTasks.id.count();
    final row = await (selectOnly(callTasks)..addColumns([count])).getSingle();
    return row.read(count)!;
  }

  List<CallTaskDetails> _groupByTask(List<TypedResult> rows) {
    final tasks = <int, CallTaskRow>{};
    final latestAttempts = <int, ContactAttemptRow?>{};
    final appointmentsByTask = <int, List<AppointmentWithPatient>>{};
    for (final row in rows) {
      final task = row.readTable(callTasks);
      tasks[task.id] = task;
      latestAttempts[task.id] = row.readTableOrNull(_latestAttempt);
      final group = appointmentsByTask.putIfAbsent(task.id, () => []);
      final appointment = row.readTableOrNull(appointments);
      final patient = row.readTableOrNull(patients);
      if (appointment != null && patient != null) {
        group.add((appointment: appointment, patient: patient));
      }
    }
    return [
      for (final MapEntry(key: id, value: task) in tasks.entries)
        CallTaskDetails(
          task: task,
          appointments: appointmentsByTask[id]!,
          latestAttempt: latestAttempts[id],
        ),
    ];
  }
}
