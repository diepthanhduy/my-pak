import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../call_list/widgets/empty_state.dart';
import '../common/app_strings.dart';
import 'bloc/import_bloc.dart';

/// First step: picks (or receives) a PDF and parses it. On success the flow
/// moves on to the review page.
class ImportPage extends StatefulWidget {
  const ImportPage({super.key, this.sharedFilePath});

  /// PDF handed over by another app; the picker opens when null.
  final String? sharedFilePath;

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ImportBloc>().add(
      ImportStarted(sharedFilePath: widget.sharedFilePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ImportBloc>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) bloc.add(const ImportCancelled());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.importPdf)),
        body: BlocBuilder<ImportBloc, ImportState>(
          builder: (context, state) => switch (state.status) {
            ImportStatus.failure => EmptyState(
              message: state.failure == ImportFailure.noRows
                  ? AppStrings.pdfNoRows
                  : AppStrings.pdfUnreadable,
              actionLabel: AppStrings.pickAnotherPdf,
              onAction: () => bloc.add(const ImportPickPressed()),
            ),
            ImportStatus.picking => const _Progress(AppStrings.openingPicker),
            _ => const _Progress(AppStrings.readingPdf),
          },
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(message),
      ],
    ),
  );
}
