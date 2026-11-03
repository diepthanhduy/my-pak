import 'package:assistant_pak/core/utils/phone_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizePhone', () {
    for (final raw in [
      '0900 000 001',
      '0900.000.001',
      '+84 900 000 001',
      '84900000001',
      '0900-000-001',
      '(0900) 000 001',
      ' 0900000001 ',
    ]) {
      test('"$raw" -> 0900000001', () {
        expect(normalizePhone(raw), (phone: '0900000001', hasMultiple: false));
      });
    }

    test('keeps 11-digit landlines', () {
      expect(normalizePhone('028 0000 0001').phone, '02800000001');
    });

    for (final raw in ['0900000001 / 0900000002', '0900000001-0900000002']) {
      test('"$raw" takes the first number and flags multiple', () {
        expect(normalizePhone(raw), (phone: '0900000001', hasMultiple: true));
      });
    }

    for (final raw in ['', 'abc', '090000', '1900000001', '+1 900 000 001']) {
      test('"$raw" is invalid', () {
        expect(normalizePhone(raw), (phone: null, hasMultiple: false));
      });
    }
  });
}
