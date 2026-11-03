import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/clock.dart';
import '../../domain/services/import_file_store.dart';

/// Stores copies under `<app documents>/imports/`.
@LazySingleton(as: ImportFileStore)
class AppImportFileStore implements ImportFileStore {
  const AppImportFileStore(this._clock);

  final Clock _clock;

  @override
  Future<String> copyIn(String sourcePath) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/imports');
    await directory.create(recursive: true);
    final name = _clock.now().millisecondsSinceEpoch;
    final copy = await File(sourcePath).copy('${directory.path}/$name.pdf');
    return copy.path;
  }

  @override
  Future<void> delete(String storedPath) async {
    final file = File(storedPath);
    if (await file.exists()) await file.delete();
  }
}
