import 'package:flutter/material.dart';

import '../../common/app_strings.dart';
import '../bloc/home_filter.dart';

class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  final HomeFilter selected;
  final Map<HomeFilter, int> counts;
  final ValueChanged<HomeFilter> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        for (final filter in HomeFilter.values)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('${_label(filter)} (${counts[filter] ?? 0})'),
              selected: filter == selected,
              onSelected: (_) => onSelected(filter),
            ),
          ),
      ],
    ),
  );

  static String _label(HomeFilter filter) => switch (filter) {
    HomeFilter.all => AppStrings.filterAll,
    HomeFilter.pending => AppStrings.filterPending,
    HomeFilter.retry => AppStrings.filterRetry,
    HomeFilter.done => AppStrings.filterDone,
    HomeFilter.unreachable => AppStrings.filterUnreachable,
  };
}
