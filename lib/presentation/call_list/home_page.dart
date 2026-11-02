import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/services/phone_launcher.dart';
import '../common/app_strings.dart';
import '../common/effect_listener.dart';
import 'bloc/home_bloc.dart';
import 'widgets/call_task_card.dart';
import 'widgets/date_navigator.dart';
import 'widgets/empty_state.dart';
import 'widgets/progress_summary.dart';
import 'widgets/status_filter_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
    child: HomeView(phoneLauncher: getIt<PhoneLauncher>()),
  );
}

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.phoneLauncher});

  final PhoneLauncher phoneLauncher;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return EffectListener<HomeEffect>(
      effects: bloc.effects,
      onEffect: _handleEffect,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                previous.selectedDate != current.selectedDate,
            builder: (context, state) => DateNavigator(
              date: state.selectedDate,
              today: state.today,
              onPrevious: () =>
                  bloc.add(HomeDateChanged(addDays(state.selectedDate, -1))),
              onNext: () =>
                  bloc.add(HomeDateChanged(addDays(state.selectedDate, 1))),
              onPick: () => _pickDate(context, state),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => bloc.add(const HomeSettingsPressed()),
              tooltip: AppStrings.settings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => switch (state.status) {
            HomeStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            HomeStatus.failure => EmptyState(
              message: AppStrings.loadFailed,
              actionLabel: AppStrings.retry,
              onAction: () => bloc.add(const HomeRetryPressed()),
            ),
            HomeStatus.success when state.isEmptyDay => EmptyState(
              message: AppStrings.emptyDay,
              actionLabel: AppStrings.importPdf,
              onAction: () => bloc.add(const HomeImportPressed()),
            ),
            HomeStatus.success => _DayContent(state: state),
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => bloc.add(const HomeImportPressed()),
          icon: const Icon(Icons.upload_file),
          label: const Text(AppStrings.importPdf),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, HomeState state) async {
    final bloc = context.read<HomeBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(state.today.year - 2),
      lastDate: DateTime(state.today.year + 2, 12, 31),
      currentDate: state.today,
      helpText: AppStrings.pickDate,
    );
    if (picked != null) bloc.add(HomeDateChanged(picked));
  }

  Future<void> _handleEffect(BuildContext context, HomeEffect effect) async {
    switch (effect) {
      case LaunchCall(:final phone):
        final launched = await phoneLauncher.startCall(phone);
        if (!launched && context.mounted) {
          _showMessage(context, AppStrings.launchCallFailed);
        }
      case LaunchSms(:final phone, :final body):
        final launched = await phoneLauncher.openSms(phone, body);
        if (!launched && context.mounted) {
          _showMessage(context, AppStrings.launchSmsFailed);
        }
      case NavigateTo(:final location):
        context.push(location);
      case ShowMessage(:final message):
        _showMessage(context, message);
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DayContent extends StatelessWidget {
  const _DayContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final tasks = state.visibleTasks;
    return Column(
      children: [
        ProgressSummary(
          contacted: state.contactedCount,
          total: state.tasks.length,
          patients: state.patientCount,
          retry: state.retryCount,
        ),
        StatusFilterBar(
          selected: state.filter,
          counts: state.counts,
          onSelected: (filter) => bloc.add(HomeFilterChanged(filter)),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: tasks.isEmpty
              ? const EmptyState(message: AppStrings.emptyFilter)
              : ListView.separated(
                  // New key per day/filter so the scroll position resets to top.
                  key: ValueKey((state.selectedDate, state.filter)),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: tasks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return CallTaskCard(
                      task: task,
                      maxAttempts: state.maxAttempts,
                      today: state.today,
                      onTap: () => bloc.add(HomeCallTaskOpened(task.id)),
                      onCall: () => bloc.add(HomeCallPressed(task.id)),
                      onSms: () => bloc.add(HomeSmsPressed(task.id)),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
