import '../../core/utils/age.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/call_task.dart';
import '../../domain/entities/contact_summary.dart';
import 'app_strings.dart';

/// "3 tuổi", or "8 tháng" under one year.
String formatAge(DateTime dob, DateTime reference) {
  final age = ageOf(dob, reference);
  if (age.years >= 1) return AppStrings.ageYears(age.years);
  if (age.months >= 1) return AppStrings.ageMonths(age.months);
  return AppStrings.ageUnderOneMonth;
}

/// "Hôm nay · 15/12/2025", or "Thứ Hai · 15/12/2025" for any other day.
String formatDayTitle(DateTime date, DateTime today) {
  final label = isSameDay(date, today)
      ? AppStrings.today
      : AppStrings.weekdays[date.weekday - 1];
  return '$label · ${formatDate(date)}';
}

/// "Không nghe máy · 14:32".
String formatLastContact(ContactSummary contact) {
  final label = switch ((contact.channel, contact.result)) {
    (ContactChannel.sms, _) => AppStrings.smsOpened,
    (ContactChannel.call, null) => AppStrings.callAwaitingResult,
    (ContactChannel.call, final ContactResult result) => contactResultLabel(
      result,
    ),
  };
  return '$label · ${formatTime(contact.at)}';
}

String contactResultLabel(ContactResult result) => switch (result) {
  ContactResult.confirmed => AppStrings.resultConfirmed,
  ContactResult.noAnswer => AppStrings.resultNoAnswer,
  ContactResult.busy => AppStrings.resultBusy,
  ContactResult.unreachable => AppStrings.resultUnreachable,
  ContactResult.wrongNumber => AppStrings.resultWrongNumber,
  ContactResult.rescheduled => AppStrings.resultRescheduled,
};

String callTaskStatusLabel(CallTaskStatus status) => switch (status) {
  CallTaskStatus.pending => AppStrings.statusPending,
  CallTaskStatus.retry => AppStrings.statusRetry,
  CallTaskStatus.done => AppStrings.statusDone,
  CallTaskStatus.unreachable => AppStrings.statusUnreachable,
};
