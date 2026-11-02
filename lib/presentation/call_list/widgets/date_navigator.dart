import 'package:flutter/material.dart';

import '../../common/app_strings.dart';
import '../../common/formatters.dart';

/// AppBar title: previous day · tappable date (opens picker) · next day.
class DateNavigator extends StatelessWidget {
  const DateNavigator({
    super.key,
    required this.date,
    required this.today,
    required this.onPrevious,
    required this.onNext,
    required this.onPick,
  });

  final DateTime date;
  final DateTime today;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        onPressed: onPrevious,
        tooltip: AppStrings.previousDay,
        icon: const Icon(Icons.chevron_left),
      ),
      Flexible(
        child: TextButton(
          onPressed: onPick,
          child: Text(
            formatDayTitle(date, today),
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      IconButton(
        onPressed: onNext,
        tooltip: AppStrings.nextDay,
        icon: const Icon(Icons.chevron_right),
      ),
    ],
  );
}
