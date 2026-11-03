import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/import_draft.dart';
import '../../domain/entities/import_warning.dart';
import 'appointment_list_parser.dart';
import 'pdf_text_extractor.dart';

/// Extracts and parses a stored PDF into a reviewable draft.
@lazySingleton
class PdfImportReader {
  const PdfImportReader(this._extractor, this._parser);

  final PdfTextExtractor _extractor;
  final AppointmentListParser _parser;

  Future<ImportDraft> read(String filePath) async {
    final parsed = _parser.parse(await _extractor.extract(filePath));
    final draft = ImportDraft(
      sourceFilePath: filePath,
      parsedCount: parsed.parsedCount,
      rows: parsed.rows,
      clinicName: parsed.clinicName,
      clinicPhone: parsed.clinicPhone,
      listDate: parsed.listDate,
      expectedCount: parsed.expectedCount,
      fileWarnings: parsed.warnings,
    );
    if (kDebugMode) _logCounts(draft);
    return draft;
  }

  /// Debug check against a known sample: counts only, never names or phones.
  void _logCounts(ImportDraft draft) {
    final byType = <String, int>{};
    for (final row in draft.rows) {
      for (final type in row.allWarnings) {
        byType[type.name] = (byType[type.name] ?? 0) + 1;
      }
    }
    debugPrint(
      '[import] rows=${draft.parsedCount} expected=${draft.expectedCount} '
      'phoneGroups=${draft.phoneGroupCount} '
      'fileWarnings=${[for (final w in draft.fileWarnings) w.name]} '
      'rowWarnings=$byType '
      'countMismatch=${draft.fileWarnings.contains(ImportWarningType.countMismatch)}',
    );
  }
}
