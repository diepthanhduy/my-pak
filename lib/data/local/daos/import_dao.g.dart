// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_dao.dart';

// ignore_for_file: type=lint
mixin _$ImportDaoMixin on DatabaseAccessor<AppDatabase> {
  $ImportBatchesTable get importBatches => attachedDatabase.importBatches;
  $PatientsTable get patients => attachedDatabase.patients;
  $CallTasksTable get callTasks => attachedDatabase.callTasks;
  $AppointmentsTable get appointments => attachedDatabase.appointments;
  ImportDaoManager get managers => ImportDaoManager(this);
}

class ImportDaoManager {
  final _$ImportDaoMixin _db;
  ImportDaoManager(this._db);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db.attachedDatabase, _db.importBatches);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db.attachedDatabase, _db.patients);
  $$CallTasksTableTableManager get callTasks =>
      $$CallTasksTableTableManager(_db.attachedDatabase, _db.callTasks);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db.attachedDatabase, _db.appointments);
}
