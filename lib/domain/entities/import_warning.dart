/// Problems found while parsing or reviewing an imported list.
enum ImportWarningType {
  /// File: rows read differ from the `Tổng Cộng` footer.
  countMismatch,

  /// File: no `Tổng Cộng` footer found.
  missingTotal,

  /// File: appointment dates differ; row: date differs from the list date.
  mixedDates,

  /// Row: STT gap or duplicate, or a wrapped line without its record.
  suspiciousRow,

  /// Row: no valid phone number. Blocks saving.
  invalidPhone,

  /// Row: the phone cell held several numbers; the first one is used.
  multiplePhones,

  /// Row: phone is the clinic's own number; the row is not called.
  clinicPhone,

  /// Row: date of birth or appointment date is not `dd/MM/yyyy`.
  invalidDate,

  /// Row: the medical code appears on several rows.
  duplicateMedicalCode,

  /// Row: no medical code. Blocks saving.
  missingMedicalCode,
}
