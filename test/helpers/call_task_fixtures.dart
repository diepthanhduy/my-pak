import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:assistant_pak/domain/entities/patient_appointment.dart';

// Synthetic test data only — never real patients.

PatientAppointment fakePatient({
  int stt = 1,
  String name = 'Nguyễn Văn A',
  DateTime? dob,
  String content = 'Tiêm vắc xin cúm',
}) => PatientAppointment(
  appointmentId: stt,
  stt: stt,
  medicalCode: 'YT${stt.toString().padLeft(6, '0')}',
  name: name,
  dob: dob,
  content: content,
);

CallTask fakeCallTask({
  int id = 1,
  DateTime? date,
  String? phone,
  CallTaskStatus status = CallTaskStatus.pending,
  int attemptCount = 0,
  DateTime? nextRetryAt,
  List<PatientAppointment>? patients,
  ContactSummary? lastContact,
}) => CallTask(
  id: id,
  date: date ?? DateTime(2026, 11, 2),
  phoneNormalized: phone ?? '09000000${id.toString().padLeft(2, '0')}',
  status: status,
  attemptCount: attemptCount,
  nextRetryAt: nextRetryAt,
  patients: patients ?? [fakePatient(stt: id)],
  lastContact: lastContact,
);
