/// A raw phone cell normalized to the VN local form `0xxxxxxxxx`.
///
/// [phone] is null when no valid number was found. [hasMultiple] is true when
/// the cell held several numbers; [phone] is then the first one.
typedef NormalizedPhone = ({String? phone, bool hasMultiple});

final _separators = RegExp(r'[\s.\-()]');
final _alternatives = RegExp(r'[/,;\-]');
final _localNumber = RegExp(r'^0\d{9,10}$');

/// Normalizes `0900 000 001`, `0900.000.001`, `+84 900 000 001`,
/// `84900000001`, `0900-000-001` to `0900000001`.
NormalizedPhone normalizePhone(String raw) {
  final whole = _normalizeSingle(raw);
  if (whole != null) return (phone: whole, hasMultiple: false);
  final parts = raw
      .split(_alternatives)
      .map(_normalizeSingle)
      .whereType<String>()
      .toList();
  return (phone: parts.firstOrNull, hasMultiple: parts.length > 1);
}

String? _normalizeSingle(String raw) {
  var digits = raw.replaceAll(_separators, '');
  if (digits.startsWith('+84')) {
    digits = '0${digits.substring(3)}';
  } else if (digits.startsWith('84') && digits.length == 11) {
    digits = '0${digits.substring(2)}';
  }
  return _localNumber.hasMatch(digits) ? digits : null;
}
