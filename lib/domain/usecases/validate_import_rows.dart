import '../../core/utils/phone_normalizer.dart';
import '../entities/import_row.dart';
import '../entities/import_warning.dart';

/// Recomputes the content warnings of [rows] (layout warnings are kept).
///
/// The single place for row rules, used after parsing and after every edit on
/// the review screen.
List<ImportRow> validateImportRows(
  List<ImportRow> rows, {
  String? clinicPhone,
  DateTime? listDate,
}) {
  final codeCounts = <String, int>{};
  for (final row in rows) {
    final code = row.medicalCode.trim();
    if (code.isNotEmpty) codeCounts[code] = (codeCounts[code] ?? 0) + 1;
  }
  return [
    for (final row in rows)
      row.copyWith(
        warnings: _warningsOf(row, codeCounts, clinicPhone, listDate),
      ),
  ];
}

Set<ImportWarningType> _warningsOf(
  ImportRow row,
  Map<String, int> codeCounts,
  String? clinicPhone,
  DateTime? listDate,
) {
  final phone = normalizePhone(row.phoneText);
  final code = row.medicalCode.trim();
  final appointmentDate = row.appointmentDate;
  return {
    if (phone.phone == null) ImportWarningType.invalidPhone,
    if (phone.hasMultiple) ImportWarningType.multiplePhones,
    if (phone.phone != null && phone.phone == clinicPhone)
      ImportWarningType.clinicPhone,
    if (appointmentDate == null ||
        (row.dobText.trim().isNotEmpty && row.dob == null))
      ImportWarningType.invalidDate,
    if (listDate != null &&
        appointmentDate != null &&
        appointmentDate != listDate)
      ImportWarningType.mixedDates,
    if (code.isEmpty) ImportWarningType.missingMedicalCode,
    if ((codeCounts[code] ?? 0) > 1) ImportWarningType.duplicateMedicalCode,
  };
}
