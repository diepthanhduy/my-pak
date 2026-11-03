import 'package:equatable/equatable.dart';

import '../usecases/validate_import_rows.dart';
import 'import_row.dart';
import 'import_warning.dart';

/// A parsed list under review, not saved yet.
final class ImportDraft extends Equatable {
  const ImportDraft({
    required this.sourceFilePath,
    required this.parsedCount,
    required this.rows,
    this.clinicName,
    this.clinicPhone,
    this.listDate,
    this.expectedCount,
    this.fileWarnings = const {},
  });

  /// Copy of the PDF in app storage.
  final String sourceFilePath;
  final String? clinicName;

  /// Normalized; rows with this number are not called.
  final String? clinicPhone;

  /// Most frequent appointment date.
  final DateTime? listDate;

  /// `Tổng Cộng : N` from the footer.
  final int? expectedCount;

  /// Rows read from the PDF, before any edit.
  final int parsedCount;
  final List<ImportRow> rows;
  final Set<ImportWarningType> fileWarnings;

  bool get hasCountMismatch =>
      fileWarnings.contains(ImportWarningType.countMismatch);

  /// Distinct (date, phone) pairs that will become call tasks.
  int get phoneGroupCount => {
    for (final row in rows)
      if (row.phone case final phone? when phone != clinicPhone)
        (row.appointmentDate, phone),
  }.length;

  bool get canSave => rows.isNotEmpty && !rows.any((row) => row.isBlocking);

  int get nextKey =>
      rows.fold(0, (max, row) => row.key > max ? row.key : max) + 1;

  int get nextStt =>
      rows.fold(0, (max, row) => row.stt > max ? row.stt : max) + 1;

  /// Replaces the rows and revalidates them.
  ImportDraft withRows(List<ImportRow> rows) => ImportDraft(
    sourceFilePath: sourceFilePath,
    parsedCount: parsedCount,
    rows: validateImportRows(
      rows,
      clinicPhone: clinicPhone,
      listDate: listDate,
    ),
    clinicName: clinicName,
    clinicPhone: clinicPhone,
    listDate: listDate,
    expectedCount: expectedCount,
    fileWarnings: fileWarnings,
  );

  @override
  List<Object?> get props => [
    sourceFilePath,
    clinicName,
    clinicPhone,
    listDate,
    expectedCount,
    parsedCount,
    rows,
    fileWarnings,
  ];
}
