import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/settings_entries.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [SettingsEntries])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.attachedDatabase);

  Future<Map<String, String>> getAll() async {
    final rows = await select(settingsEntries).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> put(String key, String value) =>
      into(settingsEntries).insertOnConflictUpdate(
        SettingsEntriesCompanion.insert(key: key, value: value),
      );
}
