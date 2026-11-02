import 'package:injectable/injectable.dart';

import '../../core/utils/clock.dart';
import '../entities/call_task.dart';
import '../entities/contact_summary.dart';
import '../repositories/call_task_repository.dart';
import '../repositories/settings_repository.dart';
import 'sms_template_renderer.dart';

@injectable
class SendSmsReminder {
  const SendSmsReminder(this._repository, this._settings, this._clock);

  final CallTaskRepository _repository;
  final SettingsRepository _settings;
  final Clock _clock;

  /// Builds the reminder for [task] and logs it as an SMS contact attempt.
  ///
  /// Returns the body to prefill in the SMS composer. The attempt is logged
  /// when the composer opens since the app cannot know whether Send was tapped.
  Future<String> call(CallTask task) async {
    final settings = await _settings.getReminderSettings();
    final body = renderSmsReminder(
      template: settings.smsTemplate,
      task: task,
      clinicName: settings.clinicName,
      clinicPhone: settings.clinicPhone,
    );
    await _repository.recordContactStarted(
      callTaskId: task.id,
      channel: ContactChannel.sms,
      startedAt: _clock.now(),
      smsBody: body,
    );
    return body;
  }
}
