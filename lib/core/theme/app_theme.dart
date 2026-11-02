import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _seed = Colors.teal;

  static ThemeData light() => _build(Brightness.light, StatusPalette.light);

  static ThemeData dark() => _build(Brightness.dark, StatusPalette.dark);

  static ThemeData _build(Brightness brightness, StatusPalette palette) =>
      ThemeData(
        colorSchemeSeed: _seed,
        brightness: brightness,
        useMaterial3: true,
        extensions: [palette],
      );
}

/// Semantic colors Material 3's [ColorScheme] does not provide.
@immutable
class StatusPalette extends ThemeExtension<StatusPalette> {
  const StatusPalette({
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  static const light = StatusPalette(
    successContainer: Color(0xFFC8E6C9),
    onSuccessContainer: Color(0xFF1B5E20),
    warningContainer: Color(0xFFFFE0B2),
    onWarningContainer: Color(0xFF7A4100),
  );

  static const dark = StatusPalette(
    successContainer: Color(0xFF1E4620),
    onSuccessContainer: Color(0xFFB7F0B9),
    warningContainer: Color(0xFF5C3B00),
    onWarningContainer: Color(0xFFFFDDB3),
  );

  final Color successContainer;
  final Color onSuccessContainer;
  final Color warningContainer;
  final Color onWarningContainer;

  static StatusPalette of(BuildContext context) =>
      Theme.of(context).extension<StatusPalette>() ??
      (Theme.of(context).brightness == Brightness.dark ? dark : light);

  @override
  StatusPalette copyWith({
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warningContainer,
    Color? onWarningContainer,
  }) => StatusPalette(
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
  );

  @override
  StatusPalette lerp(StatusPalette? other, double t) {
    if (other == null) return this;
    return StatusPalette(
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
    );
  }
}
