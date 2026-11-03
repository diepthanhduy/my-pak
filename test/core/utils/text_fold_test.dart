import 'package:assistant_pak/core/utils/text_fold.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('strips Vietnamese diacritics and case', () {
    expect(foldVietnamese('Tên Bệnh Nhân'), 'ten benh nhan');
    expect(foldVietnamese('ĐIỆN THOẠI'), 'dien thoai');
    expect(foldVietnamese('Tổng  Cộng'), 'tong cong');
  });

  test('handles combining marks (decomposed text)', () {
    // "Mã Y Tế" with combining tilde / acute instead of precomposed letters.
    expect(foldVietnamese('Mã Y Tế'), 'ma y te');
  });
}
