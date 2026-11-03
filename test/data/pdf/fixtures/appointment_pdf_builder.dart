// Synthetic "DANH SÁCH HẸN TÁI KHÁM" fixtures for the parser tests.
//
// Everything here is obviously fake (Nguyễn Văn A, 0900000001, YT000001, …).
// Geometry follows docs/pdf-format.md §2: A4 595 × 842 pt, top-left origin,
// ~9 pt font height, overflow lines ~13 pt below their record.
import 'dart:math' as math;

import 'package:assistant_pak/data/pdf/positioned_text.dart';

/// Table columns, left to right.
enum Col { stt, medicalCode, name, dob, address, phone, content, date }

const double fontHeight = 9;
const double charWidth = 4.2;
const double overflowPitch = 13;
const double recordGap = 4;
const double headerLineGap = 10;

/// Left edge of the data text per column (approx. ranges from §2).
const _dataLeft = {
  Col.stt: 12.0,
  Col.medicalCode: 38.0,
  Col.name: 86.0,
  Col.dob: 181.0,
  Col.address: 242.0,
  Col.phone: 358.0,
  Col.content: 428.0,
  Col.date: 516.0,
};

/// Left edge of the column header labels.
const _labelLeft = {
  Col.stt: 8.0,
  Col.medicalCode: 38.0,
  Col.name: 86.0,
  Col.dob: 181.0,
  Col.address: 242.0,
  Col.phone: 358.0,
  Col.content: 428.0,
  Col.date: 516.0,
};

const _labels = {
  Col.stt: 'STT',
  Col.medicalCode: 'Mã Y Tế',
  Col.name: 'Tên Bệnh Nhân',
  Col.dob: 'Ngày Sinh',
  Col.address: 'Địa Chỉ',
  Col.phone: 'Số ĐT',
  Col.content: 'Nội Dung',
  Col.date: 'Ngày Tái Khám',
};

/// Labels that wrap onto a second header line when `wrappedHeader` is set.
const _wrappedLabels = {
  Col.name: ('Tên Bệnh', 'Nhân'),
  Col.dob: ('Ngày', 'Sinh'),
  Col.date: ('Ngày Tái', 'Khám'),
};

/// How text is split into fragments, mimicking different extractors.
enum FragmentMode {
  /// One fragment per table cell / line.
  cell,

  /// One fragment per word, separated by a space-wide gap.
  word,

  /// Each word cut into two touching pieces (no gap).
  piece,
}

/// Something laid out on a page below the column header.
sealed class FixtureItem {
  const FixtureItem();
}

/// A record line plus optional overflow lines (~13 pt below each other).
/// A row without [Col.stt] is a bare wrapped line (no record start).
final class FixtureRow extends FixtureItem {
  const FixtureRow(this.cells, {this.overflow = const []});

  final Map<Col, String> cells;
  final List<Map<Col, String>> overflow;
}

/// Vertical blank space, e.g. to push a record to the bottom of a page.
final class FixtureSpace extends FixtureItem {
  const FixtureSpace(this.height);

  final double height;
}

const _surnames = ['Nguyễn Văn', 'Trần Thị', 'Lê Văn', 'Phạm Thị'];

String fakeCode(int n) => 'YT${n.toString().padLeft(6, '0')}';
String fakePhone(int n) => '09000000${n.toString().padLeft(2, '0')}';
String fakeName(int n) =>
    '${_surnames[(n - 1) % _surnames.length]} '
    '${String.fromCharCode(65 + (n - 1) % 26)}';

/// One patient record. Defaults are derived from [stt]; pass `''` to leave a
/// cell empty. `*Wrap` values go on a single overflow line below the record.
FixtureRow patient(
  int stt, {
  String? code,
  String? name,
  String dob = '01/01/2024',
  String? address,
  String? phone,
  String content = 'Tiêm ngừa',
  String date = '02/11/2026',
  String? codeWrap,
  String? nameWrap,
  String? dobWrap,
  String? addressWrap,
  String? phoneWrap,
  String? contentWrap,
  String? dateWrap,
  List<Map<Col, String>> moreOverflow = const [],
}) {
  final wrap = {
    Col.medicalCode: ?codeWrap,
    Col.name: ?nameWrap,
    Col.dob: ?dobWrap,
    Col.address: ?addressWrap,
    Col.phone: ?phoneWrap,
    Col.content: ?contentWrap,
    Col.date: ?dateWrap,
  };
  return FixtureRow(
    {
      Col.stt: '$stt',
      Col.medicalCode: code ?? fakeCode(stt),
      Col.name: name ?? fakeName(stt),
      Col.dob: dob,
      Col.address: address ?? 'Số $stt, Phường X',
      Col.phone: phone ?? fakePhone(stt),
      Col.content: content,
      Col.date: date,
    },
    overflow: [if (wrap.isNotEmpty) wrap, ...moreOverflow],
  );
}

/// A wrapped line without STT (continuation of some record).
FixtureRow continuation(Map<Col, String> cells) => FixtureRow(cells);

/// A synthetic appointment-list PDF, described page by page.
final class AppointmentPdf {
  const AppointmentPdf({
    required this.pages,
    this.organization = 'TRUNG TÂM Y TẾ X',
    this.clinicName = 'PHÒNG KHÁM NHI X',
    this.clinicPhoneText = '028 0000 0001',
    this.total,
    this.footerText,
    this.printDate = 'Ngày 02 tháng 11 năm 2026',
    this.pagesWithoutHeader = const {},
    this.extra = const [],
  });

  /// Items below the column header, one list per page.
  final List<List<FixtureItem>> pages;
  final String? organization;
  final String? clinicName;

  /// Raw text after `Điện thoại:`; null omits the whole phone line.
  final String? clinicPhoneText;

  /// Footer `Tổng Cộng : total`; null (and no [footerText]) omits it.
  final int? total;

  /// Overrides the footer text, e.g. `Tổng cộng: 3`.
  final String? footerText;

  /// Printed below the footer (or the last row); null omits it.
  final String? printDate;

  /// Zero-based pages whose column header band is not printed.
  final Set<int> pagesWithoutHeader;

  /// Raw fragments appended as-is (after transforms, before shuffling).
  final List<PositionedText> extra;

  /// Emits the fragments in top-left coordinates.
  ///
  /// [dx] / [xScale] move the whole table (header band and data) with
  /// `x' = x * xScale + dx`. [wrappedHeader] splits long labels over two
  /// header lines; with [centeredHeader] single-line labels sit vertically
  /// between the two. [decomposed] writes labels, `Điện thoại` and the footer
  /// with combining marks (NFD-like). [shuffleSeed] scrambles the order.
  List<PositionedText> build({
    FragmentMode mode = FragmentMode.cell,
    double dx = 0,
    double xScale = 1,
    bool wrappedHeader = false,
    bool centeredHeader = false,
    bool decomposed = false,
    int? shuffleSeed,
  }) {
    final out = <PositionedText>[];
    String label(String text) => decomposed ? decompose(text) : text;

    void emit(
      int page,
      String text,
      double left,
      double top, {
      bool table = false,
    }) {
      final scale = table ? xScale : 1.0;
      final shift = table ? dx : 0.0;
      out.addAll(
        _fragments(
          page,
          text,
          left * scale + shift,
          top,
          charWidth * scale,
          mode,
        ),
      );
    }

    for (final (pageIndex, items) in pages.indexed) {
      var y = 20.0;
      if (pageIndex == 0) {
        if (organization case final org?) emit(0, org, 20, y);
        y += 13;
        if (clinicName case final name?) emit(0, name, 20, y);
        y += 13;
        if (clinicPhoneText case final phone?) {
          emit(0, '${label('Điện thoại')}: $phone', 20, y);
        }
        y += 20;
        out.addAll(
          _fragments(
            0,
            label('DANH SÁCH HẸN TÁI KHÁM'),
            200,
            y,
            6,
            mode,
            height: 12,
          ),
        );
        y = 90;
      }

      if (!pagesWithoutHeader.contains(pageIndex)) {
        final headerTop = y;
        for (final col in Col.values) {
          final left = _labelLeft[col]!;
          final wrapped = _wrappedLabels[col];
          if (wrappedHeader && wrapped != null) {
            emit(pageIndex, label(wrapped.$1), left, headerTop, table: true);
            emit(
              pageIndex,
              label(wrapped.$2),
              left,
              headerTop + headerLineGap,
              table: true,
            );
          } else {
            final top = wrappedHeader && centeredHeader
                ? headerTop + headerLineGap / 2
                : headerTop;
            emit(pageIndex, label(_labels[col]!), left, top, table: true);
          }
        }
        y = headerTop + (wrappedHeader ? headerLineGap : 0) + fontHeight + 9;
      }

      for (final item in items) {
        switch (item) {
          case FixtureSpace(:final height):
            y += height;
          case FixtureRow(:final cells, :final overflow):
            for (final (index, line) in [cells, ...overflow].indexed) {
              for (final MapEntry(key: col, value: text) in line.entries) {
                if (text.trim().isEmpty) continue;
                emit(
                  pageIndex,
                  text,
                  _dataLeft[col]!,
                  y + index * overflowPitch,
                  table: true,
                );
              }
            }
            y += overflowPitch * (1 + overflow.length) + recordGap;
        }
      }

      if (pageIndex == pages.length - 1) {
        final footer =
            footerText ?? (total == null ? null : 'Tổng Cộng : $total');
        if (footer != null) emit(pageIndex, label(footer), 8, y + 6);
        if (printDate case final date?) emit(pageIndex, date, 400, y + 22);
      }
    }

    out.addAll(extra);
    if (shuffleSeed != null) out.shuffle(math.Random(shuffleSeed));
    return out;
  }
}

/// A single raw fragment of [text] at ([left], [top]), cell-width estimated.
PositionedText fragment(
  int pageIndex,
  String text,
  double left,
  double top, {
  double height = fontHeight,
}) => PositionedText(
  pageIndex: pageIndex,
  text: text,
  left: left,
  top: top,
  right: left + text.length * charWidth,
  bottom: top + height,
);

List<PositionedText> _fragments(
  int page,
  String text,
  double left,
  double top,
  double cw,
  FragmentMode mode, {
  double height = fontHeight,
}) {
  PositionedText piece(String s, double x) => PositionedText(
    pageIndex: page,
    text: s,
    left: x,
    top: top,
    right: x + s.length * cw,
    bottom: top + height,
  );

  if (mode == FragmentMode.cell) return [piece(text, left)];
  final result = <PositionedText>[];
  var x = left;
  for (final word in text.split(' ')) {
    if (word.isNotEmpty) {
      if (mode == FragmentMode.piece && word.length > 1) {
        final cut = word.length ~/ 2;
        result
          ..add(piece(word.substring(0, cut), x))
          ..add(piece(word.substring(cut), x + cut * cw));
      } else {
        result.add(piece(word, x));
      }
    }
    x += (word.length + 1) * cw;
  }
  return result;
}

/// Precomposed Vietnamese letters used in labels → base + combining marks.
const _decompositions = {
  'ã': 'ã',
  'á': 'á',
  'à': 'à',
  'ạ': 'ạ',
  'â': 'â',
  'Á': 'Á',
  'Ã': 'Ã',
  'ê': 'ê',
  'ế': 'ế',
  'ệ': 'ệ',
  'Ế': 'Ế',
  'ị': 'ị',
  'ỉ': 'ỉ',
  'ố': 'ố',
  'ộ': 'ộ',
  'ổ': 'ổ',
  'Ộ': 'Ộ',
  'Ổ': 'Ổ',
  'Ẹ': 'Ẹ',
};

/// Writes [text] with combining marks instead of precomposed letters.
String decompose(String text) =>
    text.split('').map((c) => _decompositions[c] ?? c).join();
