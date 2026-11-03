import 'package:equatable/equatable.dart';

/// Outcome of saving an imported list.
final class ImportSummary extends Equatable {
  const ImportSummary({
    required this.listDate,
    required this.newAppointments,
    required this.existingAppointments,
    required this.callTaskCount,
  });

  final DateTime listDate;

  /// Appointments added by this import.
  final int newAppointments;

  /// Rows skipped because the patient already had an appointment that day.
  final int existingAppointments;

  /// Call tasks the saved rows belong to (new or existing).
  final int callTaskCount;

  @override
  List<Object?> get props => [
    listDate,
    newAppointments,
    existingAppointments,
    callTaskCount,
  ];
}
