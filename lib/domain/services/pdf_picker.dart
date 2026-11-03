/// Lets the user choose a PDF file.
abstract interface class PdfPicker {
  /// Returns a readable path, or null when the user cancelled.
  Future<String?> pickPdf();

  /// Deletes temporary copies the picker made, once the file was copied.
  Future<void> clearTemporaryFiles();
}
