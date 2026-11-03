import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/data/repositories/drift_settings_repository.dart';
import 'package:assistant_pak/domain/entities/reminder_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftSettingsRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = DriftSettingsRepository(db);
  });
  tearDown(() => db.close());

  test('falls back to defaults on an empty database', () async {
    expect(
      await repository.getReminderSettings(),
      const ReminderSettings(
        smsTemplate: defaultSmsTemplate,
        clinicName: defaultClinicName,
        clinicPhone: defaultClinicPhone,
      ),
    );
  });

  test('reads persisted values', () async {
    await db.settingsDao.put(SettingsKeys.smsTemplate, 'Nhắc {ten}');
    await db.settingsDao.put(SettingsKeys.clinicName, 'ABC');
    await db.settingsDao.put(SettingsKeys.clinicPhone, '0900000000');
    await db.settingsDao.put(SettingsKeys.maxAttempts, '5');

    expect(
      await repository.getReminderSettings(),
      const ReminderSettings(
        smsTemplate: 'Nhắc {ten}',
        clinicName: 'ABC',
        clinicPhone: '0900000000',
        maxAttempts: 5,
      ),
    );
  });

  test('put overwrites a key and bad numbers fall back', () async {
    await db.settingsDao.put(SettingsKeys.maxAttempts, '4');
    await db.settingsDao.put(SettingsKeys.maxAttempts, 'abc');

    final settings = await repository.getReminderSettings();

    expect(settings.maxAttempts, defaultMaxAttempts);
  });
}
