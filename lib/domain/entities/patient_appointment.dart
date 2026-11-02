import 'package:equatable/equatable.dart';

/// A patient's appointment as shown inside a call task.
final class PatientAppointment extends Equatable {
  const PatientAppointment({
    required this.appointmentId,
    required this.stt,
    required this.medicalCode,
    required this.name,
    required this.content,
    this.dob,
  });

  final int appointmentId;

  /// Row number (STT) in the source PDF.
  final int stt;

  /// Mã Y Tế.
  final String medicalCode;
  final String name;
  final DateTime? dob;

  /// Nội Dung, e.g. the vaccine or follow-up type.
  final String content;

  @override
  List<Object?> get props => [
    appointmentId,
    stt,
    medicalCode,
    name,
    dob,
    content,
  ];
}
