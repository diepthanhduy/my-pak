import 'package:flutter/material.dart';

import '../../../domain/entities/import_warning.dart';
import 'import_warning_label.dart';

/// One chip per row warning type with its count; tapping filters the rows.
class WarningFilterBar extends StatelessWidget {
  const WarningFilterBar({
    super.key,
    required this.counts,
    required this.selected,
    required this.onSelected,
  });

  final Map<ImportWarningType, int> counts;
  final ImportWarningType? selected;
  final ValueChanged<ImportWarningType?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) return const SizedBox.shrink();
    final types = ImportWarningType.values.where(counts.containsKey);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          for (final type in types)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: const Icon(Icons.warning_amber, size: 18),
                label: Text('${type.label} (${counts[type]})'),
                selected: type == selected,
                onSelected: (on) => onSelected(on ? type : null),
              ),
            ),
        ],
      ),
    );
  }
}
