import 'package:injectable/injectable.dart';
import 'package:pdfrx/pdfrx.dart';

import 'positioned_text.dart';

/// Reads positioned text from a PDF with pdfrx. No business rules: it only
/// converts coordinates to a top-left origin and splits fragments that span
/// several table cells.
@lazySingleton
class PdfTextExtractor {
  const PdfTextExtractor();

  /// Rotated pages are skipped; the parser then reports missing rows.
  Future<List<PositionedText>> extract(String filePath) async {
    final document = await PdfDocument.openFile(filePath);
    try {
      final texts = <PositionedText>[];
      for (final (index, page) in document.pages.indexed) {
        if (page.rotation != PdfPageRotation.none) continue;
        final pageText = await page.loadStructuredText(ensureLoaded: true);
        for (final fragment in pageText.fragments) {
          texts.addAll(_splitAtCellGaps(fragment, index, page));
        }
      }
      return texts;
    } finally {
      await document.dispose();
    }
  }
}

/// Splits [fragment] wherever two characters are a cell gap apart, using the
/// character boxes. pdfrx rects have a bottom-left origin (y up).
List<PositionedText> _splitAtCellGaps(
  PdfPageTextFragment fragment,
  int pageIndex,
  PdfPage page,
) {
  final text = fragment.text;
  final rects = fragment.charRects;
  PositionedText build(String value, PdfRect rect) => PositionedText(
    pageIndex: pageIndex,
    text: value,
    left: rect.left,
    top: page.height - rect.top,
    right: rect.right,
    bottom: page.height - rect.bottom,
    pageWidth: page.width,
    pageHeight: page.height,
  );

  if (rects.length != text.length) return [build(text, fragment.bounds)];

  final pieces = <PositionedText>[];
  final buffer = StringBuffer();
  PdfRect? bounds;
  var pendingSpace = false;
  void flush() {
    if (bounds != null && buffer.isNotEmpty) {
      pieces.add(build(buffer.toString(), bounds!));
    }
    buffer.clear();
    bounds = null;
    pendingSpace = false;
  }

  for (var i = 0; i < text.length; i++) {
    final char = text[i];
    if (char.trim().isEmpty) {
      pendingSpace = buffer.isNotEmpty;
      continue;
    }
    final rect = rects[i];
    final current = bounds;
    if (current != null && isCellGap(rect.left - current.right, rect.height)) {
      flush();
    }
    if (pendingSpace) buffer.write(' ');
    pendingSpace = false;
    buffer.write(char);
    bounds = bounds?.merge(rect) ?? rect;
  }
  flush();
  return pieces;
}
