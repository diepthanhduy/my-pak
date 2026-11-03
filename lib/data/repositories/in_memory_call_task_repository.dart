import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/utils/clock.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/call_task.dart';
import '../../domain/entities/contact_summary.dart';
import '../../domain/repositories/call_task_repository.dart';
import 'synthetic_call_tasks.dart';

/// Development-only repository seeded with synthetic data (`ENV=dev`).
@LazySingleton(as: CallTaskRepository, env: [Environment.dev])
class InMemoryCallTaskRepository implements CallTaskRepository {
  InMemoryCallTaskRepository(Clock clock)
    : _tasks = buildSyntheticCallTasks(dateOnly(clock.now()));

  final List<CallTask> _tasks;
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<List<CallTask>> watchByDate(DateTime date) async* {
    final day = dateOnly(date);
    yield _tasksOn(day);
    yield* _changes.stream.map((_) => _tasksOn(day));
  }

  @override
  Future<void> recordContactStarted({
    required int callTaskId,
    required ContactChannel channel,
    required DateTime startedAt,
    String? smsBody,
  }) async {
    final index = _tasks.indexWhere((task) => task.id == callTaskId);
    if (index < 0) throw StateError('Unknown call task $callTaskId');
    _tasks[index] = _tasks[index].copyWith(
      lastContact: ContactSummary(channel: channel, at: startedAt),
    );
    _changes.add(null);
  }

  List<CallTask> _tasksOn(DateTime day) =>
      List.unmodifiable(_tasks.where((task) => isSameDay(task.date, day)));
}
