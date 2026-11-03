// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_task_dao.dart';

// ignore_for_file: type=lint
mixin _$CallTaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $CallTasksTable get callTasks => attachedDatabase.callTasks;
  $PatientsTable get patients => attachedDatabase.patients;
  $ImportBatchesTable get importBatches => attachedDatabase.importBatches;
  $AppointmentsTable get appointments => attachedDatabase.appointments;
  $ContactAttemptsTable get contactAttempts => attachedDatabase.contactAttempts;
  CallTaskDaoManager get managers => CallTaskDaoManager(this);
}

class CallTaskDaoManager {
  final _$CallTaskDaoMixin _db;
  CallTaskDaoManager(this._db);
  $$CallTasksTableTableManager get callTasks =>
      $$CallTasksTableTableManager(_db.attachedDatabase, _db.callTasks);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db.attachedDatabase, _db.patients);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db.attachedDatabase, _db.importBatches);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db.attachedDatabase, _db.appointments);
  $$ContactAttemptsTableTableManager get contactAttempts =>
      $$ContactAttemptsTableTableManager(
        _db.attachedDatabase,
        _db.contactAttempts,
      );
}
