import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/import_row.dart';
import '../common/app_strings.dart';
import 'bloc/import_bloc.dart';
import 'import_flow.dart';
import 'widgets/import_row_list.dart';
import 'widgets/import_row_sheet.dart';
import 'widgets/review_header.dart';
import 'widgets/warning_filter_bar.dart';

/// Wide screens show the source PDF next to the rows.
const _sideBySideMinWidth = 840.0;

enum _Tab { list, pdf }

/// Mandatory review of a parsed list before it is saved (IMP-08).
class ImportReviewPage extends StatefulWidget {
  const ImportReviewPage({super.key});

  @override
  State<ImportReviewPage> createState() => _ImportReviewPageState();
}

class _ImportReviewPageState extends State<ImportReviewPage> {
  var _tab = _Tab.list;

  Future<void> _cancel() async {
    final bloc = context.read<ImportBloc>();
    if (await confirmDiscardImport(context)) bloc.add(const ImportCancelled());
  }

  Future<void> _edit(ImportRow row) async {
    final bloc = context.read<ImportBloc>();
    final edited = await showImportRowSheet(context, row);
    if (edited != null) bloc.add(ImportRowSaved(edited));
  }

  void _addRow(ImportState state) {
    final draft = state.draft;
    if (draft == null) return;
    final listDate = draft.listDate;
    _edit(
      ImportRow(
        key: draft.nextKey,
        stt: draft.nextStt,
        medicalCode: '',
        name: '',
        dateText: listDate == null ? '' : formatDate(listDate),
        isManual: true,
      ),
    );
  }

  void _delete(ImportRow row) {
    final bloc = context.read<ImportBloc>()..add(ImportRowDeleted(row.key));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(AppStrings.rowDeleted),
          action: SnackBarAction(
            label: AppStrings.undo,
            onPressed: () => bloc.add(ImportRowSaved(row)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ImportBloc>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: BlocBuilder<ImportBloc, ImportState>(
        builder: (context, state) {
          final draft = state.draft;
          if (draft == null) return const Scaffold();
          final saving = state.status == ImportStatus.saving;
          final rows = ImportRowList(
            rows: state.visibleRows,
            clinicPhone: draft.clinicPhone,
            onEdit: _edit,
            onDelete: _delete,
          );
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                tooltip: AppStrings.cancel,
                onPressed: _cancel,
              ),
              title: const Text(AppStrings.reviewTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_add_alt),
                  tooltip: AppStrings.addRow,
                  onPressed: saving ? null : () => _addRow(state),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final sideBySide = constraints.maxWidth >= _sideBySideMinWidth;
                final listPane = Column(
                  children: [
                    ReviewHeader(draft: draft),
                    WarningFilterBar(
                      counts: state.rowWarningCounts,
                      selected: state.warningFilter,
                      onSelected: (type) =>
                          bloc.add(ImportWarningFilterChanged(type)),
                    ),
                    if (!sideBySide)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: SegmentedButton<_Tab>(
                          segments: const [
                            ButtonSegment(
                              value: _Tab.list,
                              label: Text(AppStrings.listTab),
                            ),
                            ButtonSegment(
                              value: _Tab.pdf,
                              label: Text(AppStrings.pdfTab),
                            ),
                          ],
                          selected: {_tab},
                          onSelectionChanged: (tabs) =>
                              setState(() => _tab = tabs.first),
                        ),
                      ),
                    Expanded(
                      child: !sideBySide && _tab == _Tab.pdf
                          ? PdfViewer.file(draft.sourceFilePath)
                          : rows,
                    ),
                  ],
                );
                if (!sideBySide) return listPane;
                return Row(
                  children: [
                    Expanded(child: listPane),
                    const VerticalDivider(width: 1),
                    Expanded(child: PdfViewer.file(draft.sourceFilePath)),
                  ],
                );
              },
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.blockingCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppStrings.blockingRows(state.blockingCount),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    FilledButton(
                      onPressed: state.canSave
                          ? () => bloc.add(const ImportSavePressed())
                          : null,
                      child: saving
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(AppStrings.saveList),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
