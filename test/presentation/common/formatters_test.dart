import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:assistant_pak/presentation/common/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 11, 2);

  group('formatAge', () {
    test('uses years from one year old', () {
      expect(formatAge(DateTime(2023, 5, 10), today), '3 tuổi');
      expect(formatAge(DateTime(2025, 11, 2), today), '1 tuổi');
    });

    test('uses months under one year', () {
      expect(formatAge(DateTime(2026, 3, 1), today), '8 tháng');
    });

    test('does not count a month before the day-of-month is reached', () {
      expect(formatAge(DateTime(2025, 11, 3), today), '11 tháng');
    });

    test('handles newborns and future dates', () {
      expect(formatAge(DateTime(2026, 10, 20), today), 'Dưới 1 tháng');
      expect(formatAge(DateTime(2027, 1, 1), today), 'Dưới 1 tháng');
    });
  });

  group('formatDayTitle', () {
    test('labels today as "Hôm nay"', () {
      expect(formatDayTitle(today, today), 'Hôm nay · 02/11/2026');
    });

    test('labels other days with the weekday', () {
      expect(
        formatDayTitle(DateTime(2025, 12, 15), today),
        'Thứ Hai · 15/12/2025',
      );
      expect(
        formatDayTitle(DateTime(2026, 11, 8), today),
        'Chủ Nhật · 08/11/2026',
      );
    });
  });

  group('formatLastContact', () {
    test('shows the call result and time', () {
      final contact = ContactSummary(
        channel: ContactChannel.call,
        at: DateTime(2026, 11, 2, 14, 32),
        result: ContactResult.noAnswer,
      );
      expect(formatLastContact(contact), 'Không nghe máy · 14:32');
    });

    test('shows a pending call and an opened SMS', () {
      final at = DateTime(2026, 11, 2, 9, 5);
      expect(
        formatLastContact(ContactSummary(channel: ContactChannel.call, at: at)),
        'Đã gọi, chưa ghi kết quả · 09:05',
      );
      expect(
        formatLastContact(ContactSummary(channel: ContactChannel.sms, at: at)),
        'Đã mở SMS · 09:05',
      );
    });
  });
}
