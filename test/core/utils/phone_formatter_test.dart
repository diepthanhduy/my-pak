import 'package:assistant_pak/core/utils/phone_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatPhone', () {
    test('groups a 10-digit mobile number as 4-3-3', () {
      expect(formatPhone('0900123456'), '0900 123 456');
    });

    test('groups an 11-digit landline number as 4-3-4', () {
      expect(formatPhone('02800123456'), '0280 012 3456');
    });

    test('returns other lengths unchanged', () {
      expect(formatPhone('12345'), '12345');
    });
  });
}
