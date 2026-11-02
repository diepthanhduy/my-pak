import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/call_task.dart';
import '../../common/formatters.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final CallTaskStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = StatusPalette.of(context);
    final (background, foreground) = switch (status) {
      CallTaskStatus.pending => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      CallTaskStatus.retry => (
        palette.warningContainer,
        palette.onWarningContainer,
      ),
      CallTaskStatus.done => (
        palette.successContainer,
        palette.onSuccessContainer,
      ),
      CallTaskStatus.unreachable => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
    };
    return Pill(
      label: callTaskStatusLabel(status),
      background: background,
      foreground: foreground,
    );
  }
}

/// Small rounded label used for badges and counters.
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: foreground),
      ),
    ),
  );
}
