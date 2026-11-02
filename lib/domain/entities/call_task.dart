import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'contact_summary.dart';
import 'patient_appointment.dart';

enum CallTaskStatus { pending, retry, done, unreachable }

/// One phone number to contact on a given day, grouping every patient that
/// shares it.
final class CallTask extends Equatable {
  const CallTask({
    required this.id,
    required this.date,
    required this.phoneNormalized,
    required this.patients,
    this.status = CallTaskStatus.pending,
    this.attemptCount = 0,
    this.nextRetryAt,
    this.lastContact,
  });

  final int id;
  final DateTime date;
  final String phoneNormalized;
  final CallTaskStatus status;
  final int attemptCount;
  final DateTime? nextRetryAt;
  final List<PatientAppointment> patients;
  final ContactSummary? lastContact;

  /// Lowest STT of the group, i.e. its position in the source PDF.
  int get firstStt =>
      patients.isEmpty ? 0 : patients.map((p) => p.stt).reduce(math.min);

  CallTask copyWith({
    CallTaskStatus? status,
    int? attemptCount,
    DateTime? nextRetryAt,
    List<PatientAppointment>? patients,
    ContactSummary? lastContact,
  }) => CallTask(
    id: id,
    date: date,
    phoneNormalized: phoneNormalized,
    patients: patients ?? this.patients,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    nextRetryAt: nextRetryAt ?? this.nextRetryAt,
    lastContact: lastContact ?? this.lastContact,
  );

  @override
  List<Object?> get props => [
    id,
    date,
    phoneNormalized,
    status,
    attemptCount,
    nextRetryAt,
    patients,
    lastContact,
  ];
}
