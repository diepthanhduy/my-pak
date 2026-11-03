import 'package:injectable/injectable.dart';

import '../../domain/entities/import_draft.dart';
import '../../domain/entities/import_summary.dart';
import '../../domain/repositories/import_repository.dart';
import '../pdf/pdf_import_reader.dart';

/// `ENV=dev`: parses real PDFs so the review screen can be tried, but there is
/// no database to save into.
@LazySingleton(as: ImportRepository, env: [Environment.dev])
class DevImportRepository implements ImportRepository {
  const DevImportRepository(this._reader);

  final PdfImportReader _reader;

  @override
  Future<ImportDraft> parse(String filePath) => _reader.read(filePath);

  @override
  Future<ImportSummary> save(ImportDraft draft) =>
      throw UnsupportedError('Saving needs ENV=prod');
}
