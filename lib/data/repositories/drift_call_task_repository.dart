import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/call_task.dart';
import '../../domain/entities/contact_summary.dart';
import '../../domain/repositories/call_task_repository.dart';
import '../local/app_database.dart';
import '../local/mappers/call_task_mapper.dart';

@LazySingleton(as: CallTaskRepository, env: [Environment.prod])
class DriftCallTaskRepository implements CallTaskRepository {
  const DriftCallTaskRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<CallTask>> watchByDate(DateTime date) => _db.callTaskDao
      .watchByDate(dateOnly(date))
      .map((rows) => [for (final row in rows) row.toEntity()]);

  @override
  Future<void> recordContactStarted({
    required int callTaskId,
    required ContactChannel channel,
    required DateTime startedAt,
    String? smsBody,
  }) async {
    await _db.contactAttemptDao.insertAttempt(
      ContactAttemptsCompanion.insert(
        callTaskId: callTaskId,
        channel: channel,
        startedAt: startedAt,
        smsBody: Value(smsBody),
      ),
    );
  }
}
