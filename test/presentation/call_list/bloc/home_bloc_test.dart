import 'package:assistant_pak/core/utils/clock.dart';
import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/reminder_settings.dart';
import 'package:assistant_pak/domain/repositories/settings_repository.dart';
import 'package:assistant_pak/domain/usecases/send_sms_reminder.dart';
import 'package:assistant_pak/domain/usecases/start_call.dart';
import 'package:assistant_pak/domain/usecases/watch_call_tasks_by_date.dart';
import 'package:assistant_pak/presentation/call_list/bloc/home_bloc.dart';
import 'package:assistant_pak/presentation/common/app_routes.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/call_task_fixtures.dart';

class _MockWatchCallTasks extends Mock implements WatchCallTasksByDate {}

class _MockStartCall extends Mock implements StartCall {}

class _MockSendSmsReminder extends Mock implements SendSmsReminder {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _MockClock extends Mock implements Clock {}

void main() {
  final now = DateTime(2026, 11, 2, 9, 30);
  final today = DateTime(2026, 11, 2);
  final tomorrow = DateTime(2026, 11, 3);

  final groupTask = fakeCallTask(
    id: 1,
    phone: '0900000001',
    patients: [
      fakePatient(stt: 1, name: 'Nguyễn Văn A'),
      fakePatient(stt: 2, name: 'Nguyễn Thị B'),
      fakePatient(stt: 3, name: 'Nguyễn Văn C'),
    ],
  );
  final todayTasks = [
    groupTask,
    fakeCallTask(id: 2, status: CallTaskStatus.retry, attemptCount: 2),
    fakeCallTask(id: 3, status: CallTaskStatus.done, attemptCount: 1),
    fakeCallTask(id: 4, status: CallTaskStatus.unreachable, attemptCount: 3),
  ];
  final tomorrowTasks = [fakeCallTask(id: 9, date: tomorrow)];

  late _MockWatchCallTasks watchCallTasks;
  late _MockStartCall startCall;
  late _MockSendSmsReminder sendSmsReminder;
  late _MockSettingsRepository settings;
  late _MockClock clock;
  late List<HomeEffect> effects;

  setUpAll(() {
    registerFallbackValue(DateTime(2000));
    registerFallbackValue(fakeCallTask());
  });

  setUp(() {
    watchCallTasks = _MockWatchCallTasks();
    startCall = _MockStartCall();
    sendSmsReminder = _MockSendSmsReminder();
    settings = _MockSettingsRepository();
    clock = _MockClock();
    effects = [];

    when(() => clock.now()).thenReturn(now);
    when(() => settings.getReminderSettings()).thenAnswer(
      (_) async => const ReminderSettings(
        smsTemplate: defaultSmsTemplate,
        clinicName: 'ABC',
        clinicPhone: '0900000000',
        maxAttempts: 5,
      ),
    );
    when(() => watchCallTasks(any())).thenAnswer((invocation) {
      final date = invocation.positionalArguments.first as DateTime;
      return Stream.value(date == tomorrow ? tomorrowTasks : todayTasks);
    });
  });

  HomeBloc buildBloc() {
    final bloc = HomeBloc(
      watchCallTasks,
      startCall,
      sendSmsReminder,
      settings,
      clock,
    );
    bloc.effects.listen(effects.add);
    return bloc;
  }

  HomeState loadedState({HomeFilter filter = HomeFilter.all}) => HomeState(
    today: today,
    selectedDate: today,
    filter: filter,
    tasks: todayTasks,
    status: HomeStatus.success,
    maxAttempts: 5,
  );

  test('initial state is loading for today', () {
    final bloc = buildBloc();
    expect(bloc.state, HomeState(today: today, selectedDate: today));
    bloc.close();
  });

  group('HomeStarted', () {
    blocTest<HomeBloc, HomeState>(
      'loads settings then emits the tasks of today',
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeStarted()),
      expect: () => [
        HomeState(today: today, selectedDate: today, maxAttempts: 5),
        loadedState(),
      ],
      verify: (_) => verify(() => watchCallTasks(today)).called(1),
    );

    blocTest<HomeBloc, HomeState>(
      'opens on the given date, e.g. right after an import',
      build: buildBloc,
      act: (bloc) => bloc.add(HomeStarted(date: DateTime(2026, 11, 3, 14))),
      expect: () => [
        HomeState(today: today, selectedDate: tomorrow),
        HomeState(today: today, selectedDate: tomorrow, maxAttempts: 5),
        HomeState(
          today: today,
          selectedDate: tomorrow,
          tasks: tomorrowTasks,
          status: HomeStatus.success,
          maxAttempts: 5,
        ),
      ],
      verify: (_) => verify(() => watchCallTasks(tomorrow)).called(1),
    );

    blocTest<HomeBloc, HomeState>(
      'emits failure when the stream errors',
      setUp: () => when(
        () => watchCallTasks(any()),
      ).thenAnswer((_) => Stream.error(Exception('db'))),
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeStarted()),
      expect: () => [
        HomeState(today: today, selectedDate: today, maxAttempts: 5),
        HomeState(
          today: today,
          selectedDate: today,
          maxAttempts: 5,
          status: HomeStatus.failure,
        ),
      ],
    );
  });

  group('HomeFilterChanged', () {
    blocTest<HomeBloc, HomeState>(
      'keeps all tasks and counts, narrows visible tasks',
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc.add(const HomeFilterChanged(HomeFilter.retry)),
      expect: () => [loadedState(filter: HomeFilter.retry)],
      verify: (bloc) {
        expect(bloc.state.visibleTasks.map((t) => t.id), [2]);
        expect(bloc.state.counts, {
          HomeFilter.all: 4,
          HomeFilter.pending: 1,
          HomeFilter.retry: 1,
          HomeFilter.done: 1,
          HomeFilter.unreachable: 1,
        });
        expect(bloc.state.contactedCount, 3);
        expect(bloc.state.patientCount, 6);
      },
    );
  });

  group('HomeDateChanged', () {
    blocTest<HomeBloc, HomeState>(
      'shows loading then the tasks of the new day, keeping the filter',
      build: buildBloc,
      seed: () => loadedState(filter: HomeFilter.pending),
      act: (bloc) => bloc.add(HomeDateChanged(DateTime(2026, 11, 3, 18))),
      expect: () => [
        HomeState(
          today: today,
          selectedDate: tomorrow,
          filter: HomeFilter.pending,
          maxAttempts: 5,
        ),
        HomeState(
          today: today,
          selectedDate: tomorrow,
          filter: HomeFilter.pending,
          tasks: tomorrowTasks,
          status: HomeStatus.success,
          maxAttempts: 5,
        ),
      ],
      verify: (_) => verify(() => watchCallTasks(tomorrow)).called(1),
    );

    blocTest<HomeBloc, HomeState>(
      'ignores the already selected day',
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc.add(HomeDateChanged(DateTime(2026, 11, 2, 20))),
      expect: () => <HomeState>[],
    );
  });

  group('effects', () {
    blocTest<HomeBloc, HomeState>(
      'call records the start then launches the call',
      setUp: () => when(() => startCall(any())).thenAnswer((_) async {}),
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc.add(const HomeCallPressed(1)),
      expect: () => <HomeState>[],
      verify: (_) {
        verify(() => startCall(groupTask)).called(1);
        expect(effects, [const LaunchCall('0900000001')]);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'call shows a message and does not launch when recording fails',
      setUp: () => when(() => startCall(any())).thenThrow(Exception('db')),
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc.add(const HomeCallPressed(1)),
      verify: (_) => expect(effects, [isA<ShowMessage>()]),
    );

    blocTest<HomeBloc, HomeState>(
      'SMS opens the composer with the rendered body',
      setUp: () => when(
        () => sendSmsReminder(any()),
      ).thenAnswer((_) async => 'Nhắc lịch'),
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc.add(const HomeSmsPressed(1)),
      verify: (_) {
        verify(() => sendSmsReminder(groupTask)).called(1);
        expect(effects, [const LaunchSms('0900000001', 'Nhắc lịch')]);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'unknown task id does nothing',
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc
        ..add(const HomeCallPressed(99))
        ..add(const HomeSmsPressed(99)),
      verify: (_) {
        verifyNever(() => startCall(any()));
        verifyNever(() => sendSmsReminder(any()));
        expect(effects, isEmpty);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'navigation events emit NavigateTo',
      build: buildBloc,
      seed: loadedState,
      act: (bloc) => bloc
        ..add(const HomeCallTaskOpened(3))
        ..add(const HomeImportPressed())
        ..add(const HomeSettingsPressed()),
      verify: (_) => expect(effects, [
        NavigateTo(AppRoutes.callTask(3)),
        const NavigateTo(AppRoutes.importPdf),
        const NavigateTo(AppRoutes.settings),
      ]),
    );
  });
}
