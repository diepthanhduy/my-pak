/// Formats a normalized VN phone number for display.
///
/// `0918602480` -> `0918 602 480`, `02838123456` -> `0283 812 3456`.
/// Anything else is returned unchanged.
String formatPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  return switch (digits.length) {
    10 =>
      '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}',
    11 =>
      '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}',
    _ => phone,
  };
}
