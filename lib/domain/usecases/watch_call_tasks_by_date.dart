import 'package:injectable/injectable.dart';

import '../../core/utils/date_utils.dart';
import '../entities/call_task.dart';
import '../repositories/call_task_repository.dart';
import 'call_task_sorting.dart';

@injectable
class WatchCallTasksByDate {
  const WatchCallTasksByDate(this._repository);

  final CallTaskRepository _repository;

  /// Emits the day's call tasks in display order whenever they change.
  Stream<List<CallTask>> call(DateTime date) =>
      _repository.watchByDate(dateOnly(date)).map(sortCallTasks);
}
