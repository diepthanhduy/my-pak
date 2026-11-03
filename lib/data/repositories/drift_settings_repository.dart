import 'package:injectable/injectable.dart';

import '../../domain/entities/reminder_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../local/app_database.dart';

/// Keys of the `settings` table.
abstract final class SettingsKeys {
  static const smsTemplate = 'sms_template';
  static const clinicName = 'clinic_name';
  static const clinicPhone = 'clinic_phone';
  static const maxAttempts = 'max_attempts';

  /// Last values read from an imported PDF header; user values win.
  static const detectedClinicName = 'detected_clinic_name';
  static const detectedClinicPhone = 'detected_clinic_phone';
}

@LazySingleton(as: SettingsRepository, env: [Environment.prod])
class DriftSettingsRepository implements SettingsRepository {
  const DriftSettingsRepository(this._db);

  final AppDatabase _db;

  /// Missing or unparsable values fall back to the defaults.
  @override
  Future<ReminderSettings> getReminderSettings() async {
    final values = await _db.settingsDao.getAll();
    return ReminderSettings(
      smsTemplate: values[SettingsKeys.smsTemplate] ?? defaultSmsTemplate,
      clinicName:
          values[SettingsKeys.clinicName] ??
          values[SettingsKeys.detectedClinicName] ??
          defaultClinicName,
      clinicPhone:
          values[SettingsKeys.clinicPhone] ??
          values[SettingsKeys.detectedClinicPhone] ??
          defaultClinicPhone,
      maxAttempts:
          int.tryParse(values[SettingsKeys.maxAttempts] ?? '') ??
          defaultMaxAttempts,
    );
  }
}
