import 'package:assistant_pak/domain/entities/import_row.dart';
import 'package:assistant_pak/domain/entities/import_warning.dart';
import 'package:assistant_pak/domain/usecases/validate_import_rows.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/import_fixtures.dart';

void main() {
  final listDate = DateTime(2025, 12, 15);

  Set<ImportWarningType> warningsOf(ImportRow row) => validateImportRows(
    [row],
    clinicPhone: '02800000001',
    listDate: listDate,
  ).single.warnings;

  test('a clean row has no warnings', () {
    expect(warningsOf(fakeImportRow()), isEmpty);
  });

  test('flags phone problems', () {
    expect(warningsOf(fakeImportRow(phoneText: 'abc')), {
      ImportWarningType.invalidPhone,
    });
    expect(warningsOf(fakeImportRow(phoneText: '0900000001 / 0900000002')), {
      ImportWarningType.multiplePhones,
    });
    expect(warningsOf(fakeImportRow(phoneText: '028 0000 0001')), {
      ImportWarningType.clinicPhone,
    });
  });

  test('flags dates', () {
    expect(warningsOf(fakeImportRow(dobText: '31/02/2024')), {
      ImportWarningType.invalidDate,
    });
    expect(warningsOf(fakeImportRow(dobText: '')), isEmpty);
    expect(warningsOf(fakeImportRow(dateText: '')), {
      ImportWarningType.invalidDate,
    });
    expect(warningsOf(fakeImportRow(dateText: '16/12/2025')), {
      ImportWarningType.mixedDates,
    });
  });

  test('flags missing and duplicate medical codes', () {
    expect(warningsOf(fakeImportRow(medicalCode: ' ')), {
      ImportWarningType.missingMedicalCode,
    });
    final rows = validateImportRows([
      fakeImportRow(key: 1, medicalCode: 'YT000001'),
      fakeImportRow(key: 2, medicalCode: 'YT000001', phoneText: '0900000002'),
      fakeImportRow(key: 3),
    ]);
    expect(rows.map((r) => r.warnings), [
      {ImportWarningType.duplicateMedicalCode},
      {ImportWarningType.duplicateMedicalCode},
      isEmpty,
    ]);
  });

  test('keeps layout warnings across revalidation', () {
    final draft = fakeImportDraft();
    final row = draft.rows.single;
    expect(row.isBlocking, isFalse);

    final edited = draft.withRows([row.copyWith(phoneText: 'abc')]);

    expect(edited.rows.single.warnings, {ImportWarningType.invalidPhone});
    expect(edited.rows.single.isBlocking, isTrue);
    expect(edited.canSave, isFalse);
  });

  group('ImportDraft', () {
    test('counts phone groups per day, excluding the clinic phone', () {
      final draft = fakeImportDraft(
        rows: [
          fakeImportRow(key: 1),
          fakeImportRow(key: 2),
          fakeImportRow(key: 3, phoneText: '0900000003'),
          fakeImportRow(key: 4, phoneText: '02800000001'),
          fakeImportRow(key: 5, phoneText: 'abc'),
        ],
      );

      expect(draft.phoneGroupCount, 2);
      expect(draft.canSave, isFalse);
      expect(draft.nextKey, 6);
      expect(draft.nextStt, 6);
    });
  });
}
