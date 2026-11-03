import 'package:flutter/material.dart';

import '../../../core/utils/phone_formatter.dart';
import '../../../domain/entities/import_row.dart';
import '../../common/app_strings.dart';
import 'import_warning_label.dart';

/// Rows grouped by phone like on Home; swipe a row to delete it.
class ImportRowList extends StatelessWidget {
  const ImportRowList({
    super.key,
    required this.rows,
    required this.clinicPhone,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ImportRow> rows;
  final String? clinicPhone;
  final ValueChanged<ImportRow> onEdit;
  final ValueChanged<ImportRow> onDelete;

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<ImportRow>>{};
    for (final row in rows) {
      (groups[row.phone ?? 'invalid-${row.key}'] ??= []).add(row);
    }
    final ordered = groups.values.toList()
      ..sort((a, b) => a.first.stt.compareTo(b.first.stt));
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: ordered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _GroupCard(
        rows: ordered[index],
        clinicPhone: clinicPhone,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.rows,
    required this.clinicPhone,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ImportRow> rows;
  final String? clinicPhone;
  final ValueChanged<ImportRow> onEdit;
  final ValueChanged<ImportRow> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phone = rows.first.phone;
    final title = switch (phone) {
      null => AppStrings.invalidPhoneGroup,
      _ when phone == clinicPhone =>
        '${formatPhone(phone)} · ${AppStrings.clinicPhoneGroup}',
      _ => formatPhone(phone),
    };
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: phone == null ? theme.colorScheme.error : null,
              ),
            ),
          ),
          for (final row in rows)
            Dismissible(
              key: ValueKey(row.key),
              direction: DismissDirection.endToStart,
              background: Container(
                color: theme.colorScheme.errorContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              onDismissed: (_) => onDelete(row),
              child: _RowTile(row: row, onTap: () => onEdit(row)),
            ),
        ],
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.row, required this.onTap});

  final ImportRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warnings = row.allWarnings;
    final details = [
      if (row.medicalCode.isNotEmpty) row.medicalCode,
      if (row.dobText.isNotEmpty) row.dobText,
      if (row.dateText.isNotEmpty) row.dateText,
    ].join(' · ');
    return ListTile(
      onTap: onTap,
      leading: Text('${row.stt}', style: theme.textTheme.titleMedium),
      title: Text(row.name.isEmpty ? '—' : row.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.isNotEmpty) Text(details),
          if (row.content.isNotEmpty) Text(row.content),
          if (warnings.isNotEmpty)
            Text(
              warnings.map((w) => w.label).join(', '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: row.isBlocking
                    ? theme.colorScheme.error
                    : theme.colorScheme.tertiary,
              ),
            ),
        ],
      ),
      trailing: warnings.isEmpty
          ? null
          : Icon(
              Icons.warning_amber,
              color: row.isBlocking
                  ? theme.colorScheme.error
                  : theme.colorScheme.tertiary,
            ),
    );
  }
}
