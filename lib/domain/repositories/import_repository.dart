import '../entities/import_draft.dart';
import '../entities/import_summary.dart';

abstract interface class ImportRepository {
  /// Reads the PDF at [filePath] (a copy in app storage) into a draft.
  Future<ImportDraft> parse(String filePath);

  /// Saves [draft] in one transaction. Re-importing a day keeps existing call
  /// tasks and contact history; only new appointments are added.
  Future<ImportSummary> save(ImportDraft draft);
}
