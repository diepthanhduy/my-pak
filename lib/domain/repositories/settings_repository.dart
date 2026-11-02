import '../entities/reminder_settings.dart';

abstract interface class SettingsRepository {
  Future<ReminderSettings> getReminderSettings();
}
