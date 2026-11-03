import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// A piece of text on a PDF page, in points with a top-left origin (y grows
/// downwards).
final class PositionedText extends Equatable {
  const PositionedText({
    required this.pageIndex,
    required this.text,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    this.pageWidth = 595,
    this.pageHeight = 842,
  });

  /// Zero-based.
  final int pageIndex;
  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double pageWidth;
  final double pageHeight;

  double get centerX => (left + right) / 2;
  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;

  @override
  List<Object?> get props => [
    pageIndex,
    text,
    left,
    top,
    right,
    bottom,
    pageWidth,
    pageHeight,
  ];
}

/// Whether a horizontal [gap] between two pieces of text of [fontHeight]
/// separates two table cells rather than two words.
bool isCellGap(double gap, double fontHeight) =>
    gap > math.max(4.0, fontHeight * 0.5);
