import 'package:assistant_pak/domain/entities/import_draft.dart';
import 'package:assistant_pak/domain/entities/import_row.dart';

// Synthetic test data only — never real patients.

ImportRow fakeImportRow({
  int key = 1,
  int? stt,
  String? medicalCode,
  String name = 'Nguyễn Văn A',
  String dobText = '01/01/2024',
  String phoneText = '0900000001',
  String content = 'Tiêm ngừa',
  String dateText = '15/12/2025',
}) => ImportRow(
  key: key,
  stt: stt ?? key,
  medicalCode: medicalCode ?? 'YT${key.toString().padLeft(6, '0')}',
  name: name,
  dobText: dobText,
  phoneText: phoneText,
  content: content,
  dateText: dateText,
);

/// A validated draft for 15/12/2025.
ImportDraft fakeImportDraft({
  List<ImportRow>? rows,
  String? clinicPhone = '02800000001',
  String sourceFilePath = '/tmp/imports/1.pdf',
  int? expectedCount,
}) {
  final draftRows = rows ?? [fakeImportRow()];
  return ImportDraft(
    sourceFilePath: sourceFilePath,
    parsedCount: draftRows.length,
    rows: const [],
    clinicName: 'Phòng khám ABC',
    clinicPhone: clinicPhone,
    listDate: DateTime(2025, 12, 15),
    expectedCount: expectedCount ?? draftRows.length,
  ).withRows(draftRows);
}
