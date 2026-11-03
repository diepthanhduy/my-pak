import 'package:drift/drift.dart';

import '../../../domain/entities/contact_summary.dart';
import 'call_tasks.dart';

@DataClassName('ContactAttemptRow')
@TableIndex(
  name: 'contact_attempts_call_task_started_at',
  columns: {#callTaskId, #startedAt},
)
class ContactAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get callTaskId =>
      integer().references(CallTasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get channel => textEnum<ContactChannel>()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get returnedAt => dateTime().nullable()();

  /// Null for SMS and for a call still awaiting its result.
  TextColumn get result => textEnum<ContactResult>().nullable()();
  IntColumn get durationSec => integer().nullable()();
  TextColumn get source => textEnum<ContactSource>().withDefault(
    Constant(ContactSource.manual.name),
  )();
  TextColumn get note => text().nullable()();
  TextColumn get smsBody => text().nullable()();
}
