import 'package:assistant_pak/core/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseDate', () {
    test('parses dd/MM/yyyy, also wrapped over two lines', () {
      expect(parseDate('15/12/2025'), DateTime(2025, 12, 15));
      expect(parseDate('1/2/2024'), DateTime(2024, 2, 1));
      expect(parseDate('01/01/ 2024'), DateTime(2024));
    });

    test('rejects other formats and impossible dates', () {
      expect(parseDate(''), isNull);
      expect(parseDate('2025-12-15'), isNull);
      expect(parseDate('31/02/2025'), isNull);
      expect(parseDate('15/13/2025'), isNull);
    });
  });

  test('formatIsoDate and parseIsoDate round-trip a day', () {
    final day = DateTime(2025, 12, 5);
    expect(formatIsoDate(day), '2025-12-05');
    expect(parseIsoDate('2025-12-05'), day);
    expect(parseIsoDate(null), isNull);
    expect(parseIsoDate('x'), isNull);
  });
}
