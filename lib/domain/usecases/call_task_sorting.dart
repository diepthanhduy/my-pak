import '../entities/call_task.dart';

/// Orders tasks for the daily list:
/// pending → retry (earliest `nextRetryAt` first) → done → unreachable,
/// ties broken by PDF order (STT). Patients inside each task are sorted by STT.
List<CallTask> sortCallTasks(List<CallTask> tasks) {
  final sorted = [
    for (final task in tasks)
      task.copyWith(
        patients: [...task.patients]..sort((a, b) => a.stt.compareTo(b.stt)),
      ),
  ];
  return sorted..sort(_compare);
}

int _compare(CallTask a, CallTask b) {
  final byStatus = _rank(a.status).compareTo(_rank(b.status));
  if (byStatus != 0) return byStatus;
  if (a.status == CallTaskStatus.retry) {
    final byRetryTime = _compareNullsLast(a.nextRetryAt, b.nextRetryAt);
    if (byRetryTime != 0) return byRetryTime;
  }
  return a.firstStt.compareTo(b.firstStt);
}

int _rank(CallTaskStatus status) => switch (status) {
  CallTaskStatus.pending => 0,
  CallTaskStatus.retry => 1,
  CallTaskStatus.done => 2,
  CallTaskStatus.unreachable => 3,
};

int _compareNullsLast(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
