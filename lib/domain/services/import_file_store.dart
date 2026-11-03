/// Keeps copies of imported PDFs in app storage.
abstract interface class ImportFileStore {
  /// Copies [sourcePath] into app storage and returns the copy's path.
  Future<String> copyIn(String sourcePath);

  /// Deletes a copy made by [copyIn]; missing files are ignored.
  Future<void> delete(String storedPath);
}
