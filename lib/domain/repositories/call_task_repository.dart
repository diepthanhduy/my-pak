import '../entities/call_task.dart';
import '../entities/contact_summary.dart';

abstract interface class CallTaskRepository {
  /// Emits the call tasks of [date] now and on every change.
  /// An empty list means no list was imported for that day.
  Stream<List<CallTask>> watchByDate(DateTime date);

  /// Logs the start of a contact attempt (result is recorded later).
  Future<void> recordContactStarted({
    required int callTaskId,
    required ContactChannel channel,
    required DateTime startedAt,
    String? smsBody,
  });
}
