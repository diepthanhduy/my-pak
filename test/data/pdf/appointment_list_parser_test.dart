import 'package:assistant_pak/data/pdf/appointment_list_parser.dart';
import 'package:assistant_pak/data/pdf/parsed_appointment_list.dart';
import 'package:assistant_pak/data/pdf/positioned_text.dart';
import 'package:assistant_pak/domain/entities/import_draft.dart';
import 'package:assistant_pak/domain/entities/import_row.dart';
import 'package:assistant_pak/domain/entities/import_warning.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/appointment_pdf_builder.dart';

// All data below is synthetic (docs/pdf-format.md §7).

const _parser = AppointmentListParser();
final _listDate = DateTime(2026, 11, 2);

ParsedAppointmentList _parse(List<PositionedText> texts) =>
    _parser.parse(texts);

/// Grouping helper from the domain: distinct (date, phone) call targets.
int _phoneGroups(ParsedAppointmentList result) => ImportDraft(
  sourceFilePath: 'synthetic.pdf',
  parsedCount: result.parsedCount,
  rows: result.rows,
  clinicPhone: result.clinicPhone,
  listDate: result.listDate,
  expectedCount: result.expectedCount,
  fileWarnings: result.warnings,
).phoneGroupCount;

ImportRow _row(ParsedAppointmentList result, int stt) =>
    result.rows.singleWhere((row) => row.stt == stt);

/// A clean three-patient list on one page.
AppointmentPdf _simpleList({int? total = 3}) => AppointmentPdf(
  pages: [
    [patient(1), patient(2), patient(3)],
  ],
  total: total,
);

/// 26 patients on two pages, 21 distinct phones (siblings share a phone),
/// some wrapped cells, footer `Tổng Cộng : 26`.
AppointmentPdf _phaseZeroList() {
  const sharesPreviousPhone = {2, 5, 9, 14, 20};
  var phoneIndex = 0;
  final rows = <FixtureRow>[];
  for (var stt = 1; stt <= 26; stt++) {
    if (!sharesPreviousPhone.contains(stt)) phoneIndex++;
    rows.add(
      patient(
        stt,
        phone: fakePhone(phoneIndex),
        nameWrap: stt % 4 == 0 ? 'Con' : null,
        addressWrap: stt % 3 == 0 ? 'Quận Y' : null,
        contentWrap: stt % 5 == 0 ? 'mũi 2' : null,
      ),
    );
  }
  return AppointmentPdf(
    pages: [rows.sublist(0, 15), rows.sublist(15)],
    total: 26,
  );
}

void main() {
  group('single page', () {
    test('reads every field of a one-line record', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(
                1,
                code: 'YT000001',
                name: 'Nguyễn Văn A',
                dob: '15/06/2024',
                address: 'Số 1, Phường X',
                phone: '0900000001',
                content: 'Tiêm ngừa',
                date: '02/11/2026',
              ),
            ],
          ],
          total: 1,
        ).build(),
      );

      expect(result.rows, hasLength(1));
      final row = result.rows.single;
      expect(row.key, 1);
      expect(row.stt, 1);
      expect(row.medicalCode, 'YT000001');
      expect(row.name, 'Nguyễn Văn A');
      expect(row.dobText, '15/06/2024');
      expect(row.dob, DateTime(2024, 6, 15));
      expect(row.address, 'Số 1, Phường X');
      expect(row.phoneText, '0900000001');
      expect(row.phone, '0900000001');
      expect(row.content, 'Tiêm ngừa');
      expect(row.dateText, '02/11/2026');
      expect(row.appointmentDate, _listDate);
      expect(row.allWarnings, isEmpty);
      expect(result.listDate, _listDate);
      expect(result.expectedCount, 1);
      expect(result.parsedCount, 1);
      expect(result.warnings, isEmpty);
    });

    test('keeps rows in PDF order with sequential keys', () {
      final result = _parse(_simpleList().build());

      expect(result.rows.map((r) => r.stt), [1, 2, 3]);
      expect(result.rows.map((r) => r.key), [1, 2, 3]);
      expect(result.rows.map((r) => r.medicalCode), [
        'YT000001',
        'YT000002',
        'YT000003',
      ]);
    });

    test('extracts clinic name and normalized clinic phone from header', () {
      final result = _parse(_simpleList().build());

      expect(result.clinicName, 'PHÒNG KHÁM NHI X');
      expect(result.clinicPhone, '02800000001');
    });

    test('header without a phone line gives no clinic name / phone', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1)],
          ],
          clinicPhoneText: null,
          total: 1,
        ).build(),
      );

      expect(result.clinicName, isNull);
      expect(result.clinicPhone, isNull);
      expect(result.rows, hasLength(1));
    });

    test('ignores the print-date line after the footer', () {
      final result = _parse(
        _simpleList().build(),
      ); // printDate defaults to 'Ngày 02 tháng 11 năm 2026'

      expect(result.rows, hasLength(3));
      expect(result.rows.last.content, 'Tiêm ngừa');
      expect(result.rows.last.dateText, '02/11/2026');
      expect(result.warnings, isEmpty);
    });

    test('empty input gives an empty result with missingTotal', () {
      final result = _parse(const []);

      expect(result.rows, isEmpty);
      expect(result.listDate, isNull);
      expect(result.warnings, {ImportWarningType.missingTotal});
    });
  });

  group('wrapped cells', () {
    test('name / address / content overflow attaches to the record above', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(
                1,
                name: 'Nguyễn Văn',
                nameWrap: 'A',
                address: 'Số 1, Phường X,',
                addressWrap: 'Quận Y',
                content: 'Tiêm ngừa',
                contentWrap: 'mũi 2',
              ),
              patient(2, name: 'Trần Thị B'),
            ],
          ],
          total: 2,
        ).build(),
      );

      expect(result.rows, hasLength(2));
      final first = result.rows.first;
      expect(first.name, 'Nguyễn Văn A');
      expect(first.address, 'Số 1, Phường X, Quận Y');
      expect(first.content, 'Tiêm ngừa mũi 2');
      expect(first.allWarnings, isEmpty);
      expect(result.rows.last.name, 'Trần Thị B');
      expect(result.rows.last.allWarnings, isEmpty);
    });

    test('wrapped dob, phone and medical code are rejoined', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(
                1,
                code: 'YT0000',
                codeWrap: '01',
                dob: '01/01/',
                dobWrap: '2024',
                phone: '0900',
                phoneWrap: '000 001',
              ),
            ],
          ],
          total: 1,
        ).build(),
      );

      final row = result.rows.single;
      expect(row.medicalCode, 'YT000001');
      expect(row.dob, DateTime(2024, 1, 1));
      expect(row.phone, '0900000001');
      expect(row.allWarnings, isEmpty);
    });

    test('several overflow lines all attach to the same record', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(
                1,
                content: 'Tiêm ngừa',
                contentWrap: 'mũi 2',
                moreOverflow: [
                  {Col.content: 'nhắc lại'},
                ],
              ),
              patient(2),
            ],
          ],
          total: 2,
        ).build(),
      );

      expect(result.rows, hasLength(2));
      expect(result.rows.first.content, 'Tiêm ngừa mũi 2 nhắc lại');
      expect(result.rows.last.content, 'Tiêm ngừa');
    });
  });

  group('multiple pages', () {
    test('skips the repeated header and reads a record right after the '
        'page break', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(1),
              const FixtureSpace(600),
              // Last record of page 1, near the bottom, with a wrapped name.
              patient(2, name: 'Trần Thị', nameWrap: 'B'),
            ],
            [patient(3), patient(4)],
          ],
          total: 4,
        ).build(),
      );

      expect(result.rows.map((r) => r.stt), [1, 2, 3, 4]);
      expect(_row(result, 2).name, 'Trần Thị B');
      expect(_row(result, 3).medicalCode, 'YT000003');
      expect(_row(result, 3).name, fakeName(3));
      expect(result.rows.expand((r) => r.allWarnings), isEmpty);
      expect(result.warnings, isEmpty);
    });

    test('text above the header band of page 2 is skipped', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1)],
            [patient(2)],
          ],
          total: 2,
          extra: [fragment(1, 'Trang 2', 500, 12)],
        ).build(),
      );

      expect(result.rows, hasLength(2));
      expect(result.rows.expand((r) => r.allWarnings), isEmpty);
    });

    test('a page without a header reuses the previous page layout', () {
      // Scaled table: fallback constants would put content / date in the
      // wrong columns, so page 2 must reuse page 1's header boundaries.
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1)],
            [patient(2), patient(3)],
          ],
          pagesWithoutHeader: {1},
          total: 3,
        ).build(xScale: 0.85),
      );

      expect(result.rows, hasLength(3));
      for (final row in result.rows) {
        expect(row.content, 'Tiêm ngừa', reason: 'stt ${row.stt}');
        expect(row.dateText, '02/11/2026', reason: 'stt ${row.stt}');
        expect(row.phone, fakePhone(row.stt), reason: 'stt ${row.stt}');
        expect(row.allWarnings, isEmpty, reason: 'stt ${row.stt}');
      }
    });

    test('without any header band the documented fallback columns are '
        'used', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2)],
          ],
          pagesWithoutHeader: {0},
          total: 2,
        ).build(),
      );

      // Header block lines come before any record and are dropped.
      expect(result.clinicName, isNull);
      expect(result.clinicPhone, isNull);
      expect(result.rows, hasLength(2));
      for (final row in result.rows) {
        expect(row.medicalCode, fakeCode(row.stt));
        expect(row.name, fakeName(row.stt));
        expect(row.phone, fakePhone(row.stt));
        expect(row.content, 'Tiêm ngừa');
        expect(row.dateText, '02/11/2026');
        expect(row.allWarnings, isEmpty);
      }
    });

    test('a wrapped line at the top of page 2 attaches to the last record '
        'of page 1 and marks it suspicious', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2, content: 'Tiêm ngừa')],
            [
              continuation({Col.content: 'mũi 2'}),
              patient(3),
            ],
          ],
          total: 3,
        ).build(),
      );

      expect(result.rows, hasLength(3));
      expect(_row(result, 2).content, 'Tiêm ngừa mũi 2');
      expect(_row(result, 2).allWarnings, {ImportWarningType.suspiciousRow});
      expect(_row(result, 1).allWarnings, isEmpty);
      expect(_row(result, 3).allWarnings, isEmpty);
    });
  });

  group('footer', () {
    test('total equal to the parsed count gives no warning', () {
      final result = _parse(_simpleList(total: 3).build());

      expect(result.expectedCount, 3);
      expect(result.parsedCount, 3);
      expect(result.warnings, isEmpty);
    });

    test('mismatched total gives countMismatch', () {
      final result = _parse(_simpleList(total: 5).build());

      expect(result.expectedCount, 5);
      expect(result.parsedCount, 3);
      expect(result.warnings, {ImportWarningType.countMismatch});
    });

    test('missing footer gives missingTotal', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2), patient(3)],
          ],
          printDate: null,
        ).build(),
      );

      expect(result.expectedCount, isNull);
      expect(result.parsedCount, 3);
      expect(result.warnings, {ImportWarningType.missingTotal});
    });

    test('print-date line is not attached to the last record when the footer '
        'is missing', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2), patient(3)],
          ],
        ).build(),
      );

      expect(result.warnings, {ImportWarningType.missingTotal});
      expect(result.rows.last.content, 'Tiêm ngừa');
      expect(result.rows.last.dateText, '02/11/2026');
      expect(result.rows.last.allWarnings, isEmpty);
    });

    test('"tổng cộng" inside a content cell is not the footer', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1, content: 'Tổng cộng 2 mũi'), patient(2)],
          ],
          total: 2,
        ).build(),
      );

      expect(result.rows, hasLength(2));
      expect(result.rows.first.content, 'Tổng cộng 2 mũi');
      expect(result.expectedCount, 2);
      expect(result.warnings, isEmpty);
    });

    for (final text in [
      'Tổng cộng: 3',
      'TỔNG CỘNG :3',
      'Tổng Cộng  :  3',
      'Tổng cộng 3',
    ]) {
      test('accepts footer variant "$text"', () {
        final result = _parse(
          AppointmentPdf(
            pages: [
              [patient(1), patient(2), patient(3)],
            ],
            footerText: text,
          ).build(),
        );

        expect(result.expectedCount, 3);
        expect(result.warnings, isEmpty);
      });
    }

    test('stops reading records after the footer', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2)],
          ],
          total: 2,
          extra: [
            // A stray record below the footer and a whole extra page.
            fragment(0, '9', 12, 300),
            fragment(0, fakeCode(9), 38, 300),
            fragment(0, fakePhone(9), 358, 300),
            fragment(0, '02/11/2026', 516, 300),
            fragment(1, '10', 12, 100),
            fragment(1, fakeCode(10), 38, 100),
          ],
        ).build(),
      );

      expect(result.rows.map((r) => r.stt), [1, 2]);
      expect(result.expectedCount, 2);
      expect(result.warnings, isEmpty);
    });
  });

  group('phones', () {
    test('patients sharing one phone keep the same normalized phone and '
        'form one group', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(1, phone: '0900000001'),
              patient(2, phone: '0900 000 001'),
              patient(3, phone: '+84 900 000 001'),
              patient(4, phone: '0900000004'),
            ],
          ],
          total: 4,
        ).build(),
      );

      expect(result.rows.take(3).map((r) => r.phone).toSet(), {'0900000001'});
      expect(_row(result, 4).phone, '0900000004');
      expect(_phoneGroups(result), 2);
      expect(result.rows.expand((r) => r.allWarnings), isEmpty);
    });

    test('phone variants normalize to 0xxxxxxxxx', () {
      final variants = {
        1: '+84 900 000 001',
        2: '0900.000.002',
        3: '0900 000 003',
        4: '84900000004',
        5: '0900-000-005',
      };
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              for (final MapEntry(key: stt, value: raw) in variants.entries)
                patient(stt, phone: raw),
            ],
          ],
          total: variants.length,
        ).build(),
      );

      for (final stt in variants.keys) {
        expect(_row(result, stt).phoneText, variants[stt]);
        expect(_row(result, stt).phone, fakePhone(stt));
        expect(_row(result, stt).allWarnings, isEmpty);
      }
    });

    test('a row with the clinic phone is flagged and not a call target', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2, phone: '028.0000.0001')],
          ],
          clinicPhoneText: '028 0000 0001',
          total: 2,
        ).build(),
      );

      expect(result.clinicPhone, '02800000001');
      expect(_row(result, 2).phone, '02800000001');
      expect(_row(result, 2).allWarnings, {ImportWarningType.clinicPhone});
      expect(_row(result, 1).allWarnings, isEmpty);
      expect(_phoneGroups(result), 1);
    });

    test('empty or unparseable phone gives invalidPhone', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1, phone: ''), patient(2, phone: '12345'), patient(3)],
          ],
          total: 3,
        ).build(),
      );

      expect(_row(result, 1).allWarnings, {ImportWarningType.invalidPhone});
      expect(_row(result, 1).isBlocking, isTrue);
      expect(_row(result, 2).allWarnings, {ImportWarningType.invalidPhone});
      expect(_row(result, 3).allWarnings, isEmpty);
    });

    test('two numbers in one cell use the first and give multiplePhones', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1, phone: '0900000001 /', phoneWrap: '0900000002')],
          ],
          total: 1,
        ).build(),
      );

      final row = result.rows.single;
      expect(row.phoneText, '0900000001 / 0900000002');
      expect(row.phone, '0900000001');
      expect(row.allWarnings, {ImportWarningType.multiplePhones});
    });
  });

  group('dates', () {
    test('mixed appointment dates use the most frequent one and flag '
        'the outliers', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(1),
              patient(2, date: '03/11/2026'),
              patient(3),
              patient(4),
            ],
          ],
          total: 4,
        ).build(),
      );

      expect(result.listDate, _listDate);
      expect(result.warnings, {ImportWarningType.mixedDates});
      expect(_row(result, 2).allWarnings, {ImportWarningType.mixedDates});
      for (final stt in [1, 3, 4]) {
        expect(_row(result, stt).allWarnings, isEmpty);
      }
    });

    test('invalid date of birth gives invalidDate', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1, dob: '31/02/2024'), patient(2, dob: '')],
          ],
          total: 2,
        ).build(),
      );

      expect(_row(result, 1).allWarnings, {ImportWarningType.invalidDate});
      expect(_row(result, 1).isBlocking, isFalse);
      // An empty dob is allowed.
      expect(_row(result, 2).allWarnings, isEmpty);
    });

    test('missing or invalid appointment date gives invalidDate', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2, date: ''), patient(3, date: '2026-11-02')],
          ],
          total: 3,
        ).build(),
      );

      expect(result.listDate, _listDate);
      expect(result.warnings, isEmpty);
      expect(_row(result, 2).allWarnings, {ImportWarningType.invalidDate});
      expect(_row(result, 2).isBlocking, isTrue);
      expect(_row(result, 3).allWarnings, {ImportWarningType.invalidDate});
    });
  });

  group('row checks', () {
    test('STT gap marks the row after the gap as suspicious', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2), patient(4), patient(5)],
          ],
          total: 4,
        ).build(),
      );

      expect(result.rows.map((r) => r.stt), [1, 2, 4, 5]);
      expect(_row(result, 4).allWarnings, {ImportWarningType.suspiciousRow});
      for (final stt in [1, 2, 5]) {
        expect(_row(result, stt).allWarnings, isEmpty);
      }
    });

    test('duplicate STT marks the repeated row as suspicious', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(1),
              patient(2),
              patient(2, code: fakeCode(3), phone: fakePhone(3)),
              patient(3, code: fakeCode(4), phone: fakePhone(4)),
            ],
          ],
          total: 4,
        ).build(),
      );

      expect(result.rows.map((r) => r.allWarnings), [
        isEmpty,
        isEmpty,
        {ImportWarningType.suspiciousRow},
        isEmpty,
      ]);
    });

    test('list not starting at STT 1 marks the first row as suspicious', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(2), patient(3)],
          ],
          total: 2,
        ).build(),
      );

      expect(_row(result, 2).allWarnings, {ImportWarningType.suspiciousRow});
      expect(_row(result, 3).allWarnings, isEmpty);
    });

    test('duplicate medical code flags every row with that code', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1), patient(2, code: 'YT000001'), patient(3)],
          ],
          total: 3,
        ).build(),
      );

      expect(_row(result, 1).allWarnings, {
        ImportWarningType.duplicateMedicalCode,
      });
      expect(_row(result, 2).allWarnings, {
        ImportWarningType.duplicateMedicalCode,
      });
      expect(_row(result, 3).allWarnings, isEmpty);
    });

    test('missing medical code gives missingMedicalCode', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [patient(1, code: ''), patient(2)],
          ],
          total: 2,
        ).build(),
      );

      expect(_row(result, 1).medicalCode, isEmpty);
      expect(_row(result, 1).allWarnings, {
        ImportWarningType.missingMedicalCode,
      });
      expect(_row(result, 1).isBlocking, isTrue);
      expect(_row(result, 2).allWarnings, isEmpty);
    });
  });

  group('layout robustness', () {
    final twoPages = AppointmentPdf(
      pages: [
        [
          patient(1, nameWrap: 'Con', contentWrap: 'mũi 2'),
          patient(2, addressWrap: 'Quận Y'),
        ],
        [patient(3), patient(4, phone: fakePhone(3))],
      ],
      total: 4,
    );

    for (final seed in [1, 7, 42, 2026]) {
      test('shuffled fragments (seed $seed) give the same result', () {
        final ordered = _parse(twoPages.build());
        final shuffled = _parse(twoPages.build(shuffleSeed: seed));

        expect(shuffled, ordered);
      });
    }

    test('shuffled word-level fragments give the same result', () {
      expect(
        _parse(twoPages.build(mode: FragmentMode.word, shuffleSeed: 3)),
        _parse(twoPages.build()),
      );
    });

    test('word-level fragments merge into one cell per column', () {
      final result = _parse(
        AppointmentPdf(
          pages: [
            [
              patient(
                1,
                name: 'Nguyễn Văn A',
                address: 'Số 1, Phường X',
                phone: '0900 000 001',
                content: 'Tiêm ngừa mũi 2',
              ),
            ],
          ],
          total: 1,
        ).build(mode: FragmentMode.word),
      );

      final row = result.rows.single;
      expect(row.name, 'Nguyễn Văn A');
      expect(row.address, 'Số 1, Phường X');
      expect(row.phoneText, '0900 000 001');
      expect(row.content, 'Tiêm ngừa mũi 2');
      expect(result.clinicName, 'PHÒNG KHÁM NHI X');
      expect(result.clinicPhone, '02800000001');
      expect(result.expectedCount, 1);
    });

    test('touching word pieces are joined without a space', () {
      final cells = _parse(twoPages.build());
      final pieces = _parse(twoPages.build(mode: FragmentMode.piece));

      expect(pieces, cells);
    });

    for (final dx in [-6.0, -3.0, 3.0, 6.0]) {
      test('table shifted by $dx pt parses the same', () {
        expect(_parse(twoPages.build(dx: dx)), _parse(twoPages.build()));
      });
    }

    test('column boundaries come from the header, not constants', () {
      // At 85 % width the content / date columns sit where the fallback
      // constants expect phone / content.
      expect(
        _parse(twoPages.build(xScale: 0.85, mode: FragmentMode.word)),
        _parse(twoPages.build()),
      );
    });

    test('wrapped header labels ("Tên Bệnh" / "Nhân") are matched', () {
      expect(
        _parse(twoPages.build(wrappedHeader: true)),
        _parse(twoPages.build()),
      );
    });

    test('wrapped header with vertically centered single labels', () {
      expect(
        _parse(twoPages.build(wrappedHeader: true, centeredHeader: true)),
        _parse(twoPages.build()),
      );
    });

    test('wrapped header in a scaled table still drives the boundaries', () {
      expect(
        _parse(
          twoPages.build(
            wrappedHeader: true,
            xScale: 0.85,
            mode: FragmentMode.word,
          ),
        ),
        _parse(twoPages.build()),
      );
    });

    test('labels written with combining marks still match', () {
      final decomposed = _parse(twoPages.build(decomposed: true, xScale: 0.85));

      expect(decomposed, _parse(twoPages.build()));
      expect(decomposed.clinicPhone, '02800000001');
      expect(decomposed.expectedCount, 4);
    });
  });

  group('Phase 0 shaped list', () {
    test('26 patients on 2 pages, 21 phone groups, footer 26', () {
      final result = _parse(_phaseZeroList().build());

      expect(result.parsedCount, 26);
      expect(result.expectedCount, 26);
      expect(result.warnings, isEmpty);
      expect(result.rows.map((r) => r.stt), [for (var i = 1; i <= 26; i++) i]);
      expect(result.rows.expand((r) => r.allWarnings), isEmpty);
      expect(result.rows.map((r) => r.phone).toSet(), hasLength(21));
      expect(_phoneGroups(result), 21);
      expect(result.listDate, _listDate);
      expect(result.clinicPhone, '02800000001');
      expect(_row(result, 4).name, '${fakeName(4)} Con');
      expect(_row(result, 15).address, 'Số 15, Phường X Quận Y');
      expect(_row(result, 16).medicalCode, 'YT000016');
      expect(_row(result, 20).content, 'Tiêm ngừa mũi 2');
    });

    test('same result from shuffled word-level fragments with a wrapped '
        'header', () {
      final pdf = _phaseZeroList();

      expect(
        _parse(
          pdf.build(
            mode: FragmentMode.word,
            wrappedHeader: true,
            shuffleSeed: 26,
          ),
        ),
        _parse(pdf.build()),
      );
    });
  });
}
