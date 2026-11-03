import 'package:drift/drift.dart';

/// Key-value app settings, so new settings need no schema migration.
@DataClassName('SettingsEntryRow')
class SettingsEntries extends Table {
  @override
  String get tableName => 'settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
