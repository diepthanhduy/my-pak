import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/clock.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/call_task.dart';
import '../../../domain/entities/reminder_settings.dart';
import '../../../domain/repositories/settings_repository.dart';
import '../../../domain/usecases/send_sms_reminder.dart';
import '../../../domain/usecases/start_call.dart';
import '../../../domain/usecases/watch_call_tasks_by_date.dart';
import '../../common/app_routes.dart';
import '../../common/app_strings.dart';
import 'home_filter.dart';

export 'home_filter.dart';

part 'home_effect.dart';
part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._watchCallTasks,
    this._startCall,
    this._sendSmsReminder,
    this._settings,
    Clock clock,
  ) : super(HomeState.initial(clock.now())) {
    on<HomeStarted>(_onStarted);
    on<HomeRetryPressed>(_onStarted);
    on<HomeDateChanged>(_onDateChanged);
    on<HomeFilterChanged>(_onFilterChanged);
    on<HomeCallPressed>(_onCallPressed);
    on<HomeSmsPressed>(_onSmsPressed);
    on<HomeCallTaskOpened>(
      (event, _) =>
          _emitEffect(NavigateTo(AppRoutes.callTask(event.callTaskId))),
    );
    on<HomeImportPressed>(
      (_, _) => _emitEffect(const NavigateTo(AppRoutes.importPdf)),
    );
    on<HomeSettingsPressed>(
      (_, _) => _emitEffect(const NavigateTo(AppRoutes.settings)),
    );
    on<_HomeTasksUpdated>(_onTasksUpdated);
    on<_HomeTasksFailed>(_onTasksFailed);
  }

  final WatchCallTasksByDate _watchCallTasks;
  final StartCall _startCall;
  final SendSmsReminder _sendSmsReminder;
  final SettingsRepository _settings;

  final _effects = StreamController<HomeEffect>.broadcast();
  StreamSubscription<List<CallTask>>? _tasksSubscription;

  Stream<HomeEffect> get effects => _effects.stream;

  Future<void> _onStarted(HomeEvent event, Emitter<HomeState> emit) async {
    // Bloc always forwards its first emit, so skip a no-op loading emit.
    if (state.status != HomeStatus.loading) {
      emit(state.copyWith(status: HomeStatus.loading));
    }
    try {
      final settings = await _settings.getReminderSettings();
      emit(state.copyWith(maxAttempts: settings.maxAttempts));
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
      return;
    }
    await _watch(state.selectedDate);
  }

  Future<void> _onDateChanged(
    HomeDateChanged event,
    Emitter<HomeState> emit,
  ) async {
    final date = dateOnly(event.date);
    if (date == state.selectedDate && state.status != HomeStatus.failure) {
      return;
    }
    emit(
      state.copyWith(
        selectedDate: date,
        tasks: const [],
        status: HomeStatus.loading,
      ),
    );
    await _watch(date);
  }

  void _onFilterChanged(HomeFilterChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onCallPressed(
    HomeCallPressed event,
    Emitter<HomeState> emit,
  ) async {
    final task = _findTask(event.callTaskId);
    if (task == null) return;
    try {
      await _startCall(task);
    } on Exception {
      _emitEffect(const ShowMessage(AppStrings.actionFailed));
      return;
    }
    _emitEffect(LaunchCall(task.phoneNormalized));
  }

  Future<void> _onSmsPressed(
    HomeSmsPressed event,
    Emitter<HomeState> emit,
  ) async {
    final task = _findTask(event.callTaskId);
    if (task == null) return;
    final String body;
    try {
      body = await _sendSmsReminder(task);
    } on Exception {
      _emitEffect(const ShowMessage(AppStrings.actionFailed));
      return;
    }
    _emitEffect(LaunchSms(task.phoneNormalized, body));
  }

  void _onTasksUpdated(_HomeTasksUpdated event, Emitter<HomeState> emit) {
    // Ignore late emissions from a day that is no longer selected.
    if (event.date != state.selectedDate) return;
    emit(state.copyWith(tasks: event.tasks, status: HomeStatus.success));
  }

  void _onTasksFailed(_HomeTasksFailed event, Emitter<HomeState> emit) {
    if (event.date != state.selectedDate) return;
    emit(state.copyWith(status: HomeStatus.failure));
  }

  Future<void> _watch(DateTime date) async {
    await _tasksSubscription?.cancel();
    _tasksSubscription = _watchCallTasks(date).listen(
      (tasks) => add(_HomeTasksUpdated(date, tasks)),
      onError: (Object _) => add(_HomeTasksFailed(date)),
    );
  }

  CallTask? _findTask(int id) {
    for (final task in state.tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void _emitEffect(HomeEffect effect) {
    if (!_effects.isClosed) _effects.add(effect);
  }

  @override
  Future<void> close() async {
    await _tasksSubscription?.cancel();
    await _effects.close();
    return super.close();
  }
}
