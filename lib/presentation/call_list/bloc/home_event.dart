part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeStarted extends HomeEvent {
  const HomeStarted({this.date});

  /// Day to open on; today when null.
  final DateTime? date;

  @override
  List<Object?> get props => [date];
}

final class HomeRetryPressed extends HomeEvent {
  const HomeRetryPressed();
}

final class HomeDateChanged extends HomeEvent {
  const HomeDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class HomeFilterChanged extends HomeEvent {
  const HomeFilterChanged(this.filter);

  final HomeFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class HomeCallPressed extends HomeEvent {
  const HomeCallPressed(this.callTaskId);

  final int callTaskId;

  @override
  List<Object?> get props => [callTaskId];
}

final class HomeSmsPressed extends HomeEvent {
  const HomeSmsPressed(this.callTaskId);

  final int callTaskId;

  @override
  List<Object?> get props => [callTaskId];
}

final class HomeCallTaskOpened extends HomeEvent {
  const HomeCallTaskOpened(this.callTaskId);

  final int callTaskId;

  @override
  List<Object?> get props => [callTaskId];
}

final class HomeImportPressed extends HomeEvent {
  const HomeImportPressed();
}

final class HomeSettingsPressed extends HomeEvent {
  const HomeSettingsPressed();
}

/// Internal: the watched day emitted new tasks.
final class _HomeTasksUpdated extends HomeEvent {
  const _HomeTasksUpdated(this.date, this.tasks);

  final DateTime date;
  final List<CallTask> tasks;

  @override
  List<Object?> get props => [date, tasks];
}

/// Internal: watching the day failed.
final class _HomeTasksFailed extends HomeEvent {
  const _HomeTasksFailed(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}
