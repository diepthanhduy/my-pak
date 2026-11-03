import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/services/pdf_picker.dart';

@LazySingleton(as: PdfPicker)
class FilePickerPdfPicker implements PdfPicker {
  const FilePickerPdfPicker();

  @override
  Future<String?> pickPdf() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    return files.firstOrNull?.path;
  }

  @override
  Future<void> clearTemporaryFiles() => FilePicker.clearTemporaryFiles();
}
