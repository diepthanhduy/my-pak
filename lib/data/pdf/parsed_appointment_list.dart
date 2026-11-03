import 'package:equatable/equatable.dart';

import '../../domain/entities/import_row.dart';
import '../../domain/entities/import_warning.dart';

/// Result of parsing a "DANH SÁCH HẸN TÁI KHÁM" PDF.
final class ParsedAppointmentList extends Equatable {
  const ParsedAppointmentList({
    required this.rows,
    this.clinicName,
    this.clinicPhone,
    this.listDate,
    this.expectedCount,
    this.warnings = const {},
  });

  /// Validated rows in PDF order.
  final List<ImportRow> rows;
  final String? clinicName;

  /// Normalized clinic phone from the `Điện thoại:` header line.
  final String? clinicPhone;

  /// Most frequent appointment date.
  final DateTime? listDate;

  /// `Tổng Cộng : N`.
  final int? expectedCount;

  /// File-level warnings; row warnings live on each row.
  final Set<ImportWarningType> warnings;

  int get parsedCount => rows.length;

  @override
  List<Object?> get props => [
    rows,
    clinicName,
    clinicPhone,
    listDate,
    expectedCount,
    warnings,
  ];
}
