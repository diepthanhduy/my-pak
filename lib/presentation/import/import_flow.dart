import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../common/app_routes.dart';
import '../common/app_strings.dart';
import '../common/effect_listener.dart';
import 'bloc/import_bloc.dart';

/// Shell of the `/import` routes: owns the [ImportBloc] shared by the pick and
/// review pages and handles its navigation effects once.
class ImportFlow extends StatelessWidget {
  const ImportFlow({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ImportBloc>(),
    child: Builder(
      builder: (context) => EffectListener<ImportEffect>(
        effects: context.read<ImportBloc>().effects,
        onEffect: _handleEffect,
        child: child,
      ),
    ),
  );

  void _handleEffect(BuildContext context, ImportEffect effect) {
    switch (effect) {
      case ShowReview():
        context.push(AppRoutes.importReview);
      case CloseImport():
        context.go(AppRoutes.home);
      case ImportFinished(:final summary):
        _showMessage(
          context,
          AppStrings.importSaved(
            summary.newAppointments,
            summary.existingAppointments,
          ),
        );
        context.go(AppRoutes.homeOn(summary.listDate));
      case ShowImportMessage(:final message):
        _showMessage(context, message);
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Asks before leaving an unsaved import; true when the user confirms.
Future<bool> confirmDiscardImport(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.discardImportTitle),
        content: const Text(AppStrings.discardImportBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.keepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.discard),
          ),
        ],
      ),
    ) ??
    false;
