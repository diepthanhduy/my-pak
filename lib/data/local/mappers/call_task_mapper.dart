import 'package:drift/drift.dart';

import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/call_task.dart';
import '../../../domain/entities/contact_summary.dart';
import '../../../domain/entities/patient_appointment.dart';
import '../app_database.dart';
import '../daos/call_task_dao.dart';

extension CallTaskDetailsMapper on CallTaskDetails {
  CallTask toEntity() => CallTask(
    id: task.id,
    date: task.date,
    phoneNormalized: task.phoneNormalized,
    status: task.status,
    attemptCount: task.attemptCount,
    nextRetryAt: task.nextRetryAt,
    patients: [
      for (final (:appointment, :patient) in appointments)
        PatientAppointment(
          appointmentId: appointment.id,
          stt: appointment.stt,
          medicalCode: patient.medicalCode,
          name: patient.name,
          dob: patient.dob,
          content: appointment.content,
        ),
    ],
    lastContact: latestAttempt?.toSummary(),
  );
}

extension ContactAttemptRowMapper on ContactAttemptRow {
  ContactSummary toSummary() =>
      ContactSummary(channel: channel, at: startedAt, result: result);
}

extension CallTaskCompanionMapper on CallTask {
  /// Keeps [CallTask.id]; patients and the last contact are stored separately.
  CallTasksCompanion toCompanion() => CallTasksCompanion.insert(
    id: Value(id),
    date: dateOnly(date),
    phoneNormalized: phoneNormalized,
    status: Value(status),
    attemptCount: Value(attemptCount),
    nextRetryAt: Value(nextRetryAt),
  );
}

extension PatientAppointmentCompanionMapper on PatientAppointment {
  PatientsCompanion toPatientCompanion({required String phoneNormalized}) =>
      PatientsCompanion.insert(
        medicalCode: medicalCode,
        name: name,
        dob: Value(dob == null ? null : dateOnly(dob!)),
        phoneNormalized: phoneNormalized,
      );

  /// Keeps [PatientAppointment.appointmentId].
  AppointmentsCompanion toAppointmentCompanion({
    required int patientId,
    required int callTaskId,
    required DateTime date,
  }) => AppointmentsCompanion.insert(
    id: Value(appointmentId),
    patientId: patientId,
    callTaskId: Value(callTaskId),
    date: dateOnly(date),
    stt: stt,
    content: content,
  );
}

extension ContactSummaryCompanionMapper on ContactSummary {
  ContactAttemptsCompanion toCompanion({required int callTaskId}) =>
      ContactAttemptsCompanion.insert(
        callTaskId: callTaskId,
        channel: channel,
        startedAt: at,
        result: Value(result),
      );
}
