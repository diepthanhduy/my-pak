import 'package:injectable/injectable.dart';

import '../entities/import_draft.dart';
import '../repositories/import_repository.dart';
import '../services/import_file_store.dart';

@injectable
class ParseAppointmentPdf {
  const ParseAppointmentPdf(this._repository, this._fileStore);

  final ImportRepository _repository;
  final ImportFileStore _fileStore;

  /// Copies [sourcePath] into app storage and parses the copy.
  /// The copy is deleted again if parsing fails.
  Future<ImportDraft> call(String sourcePath) async {
    final storedPath = await _fileStore.copyIn(sourcePath);
    try {
      return await _repository.parse(storedPath);
    } catch (_) {
      await _fileStore.delete(storedPath);
      rethrow;
    }
  }
}
