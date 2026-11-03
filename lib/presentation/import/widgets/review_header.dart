import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/utils/phone_formatter.dart';
import '../../../domain/entities/import_draft.dart';
import '../../../domain/entities/import_warning.dart';
import '../../common/app_strings.dart';

/// List date, clinic, read vs. footer count (red when they differ) and the
/// number of phone groups.
class ReviewHeader extends StatelessWidget {
  const ReviewHeader({super.key, required this.draft});

  final ImportDraft draft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listDate = draft.listDate;
    final expected = draft.expectedCount;
    final countOk = expected != null && !draft.hasCountMismatch;
    final clinic = [
      if (draft.clinicName case final name? when name.isNotEmpty) name,
      if (draft.clinicPhone case final phone?) formatPhone(phone),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.listDate(
              listDate == null ? AppStrings.unknownDate : formatDate(listDate),
            ),
            style: theme.textTheme.titleMedium,
          ),
          if (clinic.isNotEmpty)
            Text(AppStrings.clinic(clinic), style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            expected == null
                ? AppStrings.readCountNoTotal(draft.parsedCount)
                : AppStrings.readCount(draft.parsedCount, expected),
            key: const ValueKey('review-count'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: countOk ? null : theme.colorScheme.error,
              fontWeight: countOk ? null : FontWeight.bold,
            ),
          ),
          Text(
            AppStrings.phoneGroups(draft.phoneGroupCount),
            style: theme.textTheme.bodyMedium,
          ),
          if (draft.fileWarnings.contains(ImportWarningType.mixedDates))
            Text(
              AppStrings.mixedDatesNotice,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
