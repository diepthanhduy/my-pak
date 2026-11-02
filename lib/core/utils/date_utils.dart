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

/// Formats [value] as `HH:mm`.
String formatTime(DateTime value) =>
    '${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';

String _twoDigits(int value) => value.toString().padLeft(2, '0');
