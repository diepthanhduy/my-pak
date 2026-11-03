/// PDFs handed to the app by other apps (share sheet / "Open with").
abstract interface class SharedPdfSource {
  /// Path of the PDF the app was launched with, returned only once.
  Future<String?> takeInitialPdf();

  /// Paths of PDFs shared while the app is running.
  Stream<String> get sharedPdfs;
}
