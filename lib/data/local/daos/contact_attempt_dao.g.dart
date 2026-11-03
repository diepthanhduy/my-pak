// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_attempt_dao.dart';

// ignore_for_file: type=lint
mixin _$ContactAttemptDaoMixin on DatabaseAccessor<AppDatabase> {
  $CallTasksTable get callTasks => attachedDatabase.callTasks;
  $ContactAttemptsTable get contactAttempts => attachedDatabase.contactAttempts;
  ContactAttemptDaoManager get managers => ContactAttemptDaoManager(this);
}

class ContactAttemptDaoManager {
  final _$ContactAttemptDaoMixin _db;
  ContactAttemptDaoManager(this._db);
  $$CallTasksTableTableManager get callTasks =>
      $$CallTasksTableTableManager(_db.attachedDatabase, _db.callTasks);
  $$ContactAttemptsTableTableManager get contactAttempts =>
      $$ContactAttemptsTableTableManager(
        _db.attachedDatabase,
        _db.contactAttempts,
      );
}
