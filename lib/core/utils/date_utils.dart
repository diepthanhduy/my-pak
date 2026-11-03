/// Returns [value] truncated to its local calendar date (midnight).
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Returns the calendar date [days] away from [date].
DateTime addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Formats [value] as `dd/MM/yyyy`.
String formatDate(DateTime value) =>
    '${_twoDigits(value.day)}/${_twoDigits(value.month)}/${value.year}';

/// Formats [value] as `yyyy-MM-dd`, e.g. for route query parameters.
String formatIsoDate(DateTime value) =>
    '${value.year}-${_twoDigits(value.month)}-${_twoDigits(value.day)}';

/// Parses `yyyy-MM-dd` into a local date; null if absent or invalid.
DateTime? parseIsoDate(String? value) {
  final parsed = value == null ? null : DateTime.tryParse(value);
  return parsed == null ? null : dateOnly(parsed);
}

/// Formats [value] as `HH:mm`.
String formatTime(DateTime value) =>
    '${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';

String _twoDigits(int value) => value.toString().padLeft(2, '0');

final _dayMonthYear = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');

/// Parses `dd/MM/yyyy`, ignoring whitespace (cells may wrap mid-date).
/// Returns null for anything else, including impossible dates.
DateTime? parseDate(String value) {
  final match = _dayMonthYear.firstMatch(value.replaceAll(RegExp(r'\s'), ''));
  if (match == null) return null;
  final day = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  final year = int.parse(match[3]!);
  final date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) return null;
  return date;
}
