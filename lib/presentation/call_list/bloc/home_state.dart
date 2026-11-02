part of 'home_bloc.dart';

enum HomeStatus { loading, success, failure }

final class HomeState extends Equatable {
  const HomeState({
    required this.today,
    required this.selectedDate,
    this.filter = HomeFilter.all,
    this.tasks = const [],
    this.status = HomeStatus.loading,
    this.maxAttempts = defaultMaxAttempts,
  });

  HomeState.initial(DateTime now)
    : this(today: dateOnly(now), selectedDate: dateOnly(now));

  final DateTime today;
  final DateTime selectedDate;
  final HomeFilter filter;

  /// All tasks of [selectedDate], already in display order.
  final List<CallTask> tasks;
  final HomeStatus status;
  final int maxAttempts;

  List<CallTask> get visibleTasks =>
      tasks.where((task) => filter.matches(task.status)).toList();

  Map<HomeFilter, int> get counts => {
    for (final f in HomeFilter.values)
      f: tasks.where((task) => f.matches(task.status)).length,
  };

  /// Tasks with at least one recorded call result.
  int get contactedCount =>
      tasks.where((task) => task.status != CallTaskStatus.pending).length;

  int get patientCount =>
      tasks.fold(0, (sum, task) => sum + task.patients.length);

  int get retryCount =>
      tasks.where((task) => task.status == CallTaskStatus.retry).length;

  /// No list imported for [selectedDate].
  bool get isEmptyDay => status == HomeStatus.success && tasks.isEmpty;

  HomeState copyWith({
    DateTime? selectedDate,
    HomeFilter? filter,
    List<CallTask>? tasks,
    HomeStatus? status,
    int? maxAttempts,
  }) => HomeState(
    today: today,
    selectedDate: selectedDate ?? this.selectedDate,
    filter: filter ?? this.filter,
    tasks: tasks ?? this.tasks,
    status: status ?? this.status,
    maxAttempts: maxAttempts ?? this.maxAttempts,
  );

  @override
  List<Object?> get props => [
    today,
    selectedDate,
    filter,
    tasks,
    status,
    maxAttempts,
  ];
}
