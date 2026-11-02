import 'package:injectable/injectable.dart';

import '../../core/utils/clock.dart';
import '../entities/call_task.dart';
import '../entities/contact_summary.dart';
import '../repositories/call_task_repository.dart';

@injectable
class StartCall {
  const StartCall(this._repository, this._clock);

  final CallTaskRepository _repository;
  final Clock _clock;

  /// Records the call start so the result sheet can open when the app resumes.
  Future<void> call(CallTask task) => _repository.recordContactStarted(
    callTaskId: task.id,
    channel: ContactChannel.call,
    startedAt: _clock.now(),
  );
}
