import 'package:injectable/injectable.dart';

import '../entities/import_draft.dart';
import '../entities/import_summary.dart';
import '../repositories/import_repository.dart';

@injectable
class SaveImportBatch {
  const SaveImportBatch(this._repository);

  final ImportRepository _repository;

  /// Saves [draft]; throws [ArgumentError] while a row still blocks saving.
  Future<ImportSummary> call(ImportDraft draft) {
    if (!draft.canSave) {
      throw ArgumentError.value(draft.rows.length, 'draft', 'Not saveable');
    }
    return _repository.save(draft);
  }
}
