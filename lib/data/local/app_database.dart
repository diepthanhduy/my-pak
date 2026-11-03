import 'package:drift/drift.dart';

import '../../domain/entities/appointment_status.dart';
import '../../domain/entities/call_task.dart';
import '../../domain/entities/contact_summary.dart';
import '../../domain/entities/import_source_type.dart';
import 'daos/call_task_dao.dart';
import 'daos/contact_attempt_dao.dart';
import 'daos/import_dao.dart';
import 'daos/settings_dao.dart';
import 'tables/appointments.dart';
import 'tables/call_tasks.dart';
import 'tables/contact_attempts.dart';
import 'tables/import_batches.dart';
import 'tables/patients.dart';
import 'tables/settings_entries.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Patients,
    Appointments,
    CallTasks,
    ContactAttempts,
    ImportBatches,
    SettingsEntries,
  ],
  daos: [CallTaskDao, ContactAttemptDao, ImportDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opened in `core/di/database_module.dart`; tests pass
  /// `NativeDatabase.memory()`.
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
