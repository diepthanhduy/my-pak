import 'package:injectable/injectable.dart';

import '../../domain/entities/reminder_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Development-only settings with placeholder clinic info.
/// `ENV=dev` only; prod uses `DriftSettingsRepository`.
@LazySingleton(as: SettingsRepository, env: [Environment.dev])
class InMemorySettingsRepository implements SettingsRepository {
  @override
  Future<ReminderSettings> getReminderSettings() async =>
      const ReminderSettings(
        smsTemplate: defaultSmsTemplate,
        clinicName: 'ABC',
        clinicPhone: '0900000000',
      );
}
