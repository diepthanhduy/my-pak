import '../../../domain/entities/call_task.dart';

enum HomeFilter {
  all,
  pending,
  retry,
  done,
  unreachable;

  bool matches(CallTaskStatus status) => switch (this) {
    HomeFilter.all => true,
    HomeFilter.pending => status == CallTaskStatus.pending,
    HomeFilter.retry => status == CallTaskStatus.retry,
    HomeFilter.done => status == CallTaskStatus.done,
    HomeFilter.unreachable => status == CallTaskStatus.unreachable,
  };
}
