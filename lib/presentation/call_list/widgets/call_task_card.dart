import 'package:flutter/material.dart';

import '../../../core/utils/phone_formatter.dart';
import '../../../domain/entities/call_task.dart';
import '../../../domain/entities/patient_appointment.dart';
import '../../common/app_strings.dart';
import '../../common/formatters.dart';
import 'status_badge.dart';

/// One phone group: header, one line per patient, last contact, actions.
class CallTaskCard extends StatelessWidget {
  const CallTaskCard({
    super.key,
    required this.task,
    required this.maxAttempts,
    required this.today,
    required this.onTap,
    required this.onCall,
    required this.onSms,
  });

  final CallTask task;
  final int maxAttempts;

  /// Reference date for patient ages.
  final DateTime today;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onSms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastContact = task.lastContact;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(task: task, maxAttempts: maxAttempts),
              const SizedBox(height: 8),
              for (final patient in task.patients)
                _PatientLine(patient: patient, today: today),
              if (lastContact != null) ...[
                const SizedBox(height: 4),
                Text(
                  formatLastContact(lastContact),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: onSms,
                    icon: const Icon(Icons.sms_outlined),
                    label: const Text(AppStrings.sms),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone),
                    label: const Text(AppStrings.call),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.task, required this.maxAttempts});

  final CallTask task;
  final int maxAttempts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        // Phone gets all space left by the trailing badges; the group chip
        // wraps below it on narrow screens instead of truncating the number.
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                formatPhone(task.phoneNormalized),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (task.patients.length > 1)
                Pill(
                  label: AppStrings.groupSize(task.patients.length),
                  background: scheme.secondaryContainer,
                  foreground: scheme.onSecondaryContainer,
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (task.attemptCount > 0) ...[
          Text(
            AppStrings.attempt(task.attemptCount, maxAttempts),
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
        ],
        StatusBadge(status: task.status),
      ],
    );
  }
}

class _PatientLine extends StatelessWidget {
  const _PatientLine({required this.patient, required this.today});

  final PatientAppointment patient;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final dob = patient.dob;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: patient.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (dob != null) TextSpan(text: ' · ${formatAge(dob, today)}'),
            TextSpan(text: ' · ${patient.content}'),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
