import 'package:drift/drift.dart';

import '../../../domain/entities/call_task.dart';

@DataClassName('CallTaskRow')
class CallTasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Day only (local midnight).
  DateTimeColumn get date => dateTime()();
  TextColumn get phoneNormalized => text()();
  TextColumn get status => textEnum<CallTaskStatus>().withDefault(
    Constant(CallTaskStatus.pending.name),
  )();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {date, phoneNormalized},
  ];
}
