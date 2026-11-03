import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/import_draft.dart';
import '../../../domain/entities/import_row.dart';
import '../../../domain/entities/import_summary.dart';
import '../../../domain/entities/import_warning.dart';
import '../../../domain/services/import_file_store.dart';
import '../../../domain/services/pdf_picker.dart';
import '../../../domain/usecases/parse_appointment_pdf.dart';
import '../../../domain/usecases/save_import_batch.dart';
import '../../common/app_strings.dart';

part 'import_effect.dart';
part 'import_event.dart';
part 'import_state.dart';

/// Pick → parse → review → save. One bloc serves both import routes so the
/// draft lives in a single place.
@injectable
class ImportBloc extends Bloc<ImportEvent, ImportState> {
  ImportBloc(this._picker, this._parse, this._save, this._fileStore)
    : super(const ImportState()) {
    on<ImportStarted>(_onStarted);
    on<ImportPickPressed>((_, emit) => _pickAndParse(emit));
    on<ImportRowSaved>(_onRowSaved);
    on<ImportRowDeleted>(_onRowDeleted);
    on<ImportWarningFilterChanged>(
      (event, emit) => emit(
        state.copyWith(
          warningFilter: event.type,
          clearWarningFilter: event.type == null,
        ),
      ),
    );
    on<ImportSavePressed>(_onSavePressed);
    on<ImportCancelled>(_onCancelled);
  }

  final PdfPicker _picker;
  final ParseAppointmentPdf _parse;
  final SaveImportBatch _save;
  final ImportFileStore _fileStore;

  final _effects = StreamController<ImportEffect>.broadcast();

  Stream<ImportEffect> get effects => _effects.stream;

  Future<void> _onStarted(ImportStarted event, Emitter<ImportState> emit) {
    final path = event.sharedFilePath;
    return path == null ? _pickAndParse(emit) : _parsePath(path, emit);
  }

  Future<void> _pickAndParse(Emitter<ImportState> emit) async {
    final picking = state.copyWith(
      status: ImportStatus.picking,
      clearFailure: true,
    );
    // Bloc always forwards its first emit, so skip a no-op one.
    if (picking != state) emit(picking);
    final String? path;
    try {
      path = await _picker.pickPdf();
    } catch (_) {
      emit(_failed(ImportFailure.unreadable));
      return;
    }
    if (path == null) {
      _emitEffect(const CloseImport());
      return;
    }
    await _parsePath(path, emit);
    await _picker.clearTemporaryFiles();
  }

  Future<void> _parsePath(String path, Emitter<ImportState> emit) async {
    await _discardDraftFile();
    emit(const ImportState(status: ImportStatus.parsing));
    final ImportDraft draft;
    try {
      draft = await _parse(path);
    } catch (_) {
      emit(_failed(ImportFailure.unreadable));
      return;
    }
    if (draft.rows.isEmpty) {
      await _fileStore.delete(draft.sourceFilePath);
      emit(_failed(ImportFailure.noRows));
      return;
    }
    emit(ImportState(status: ImportStatus.review, draft: draft));
    _emitEffect(const ShowReview());
  }

  ImportState _failed(ImportFailure failure) =>
      ImportState(status: ImportStatus.failure, failure: failure);

  void _onRowSaved(ImportRowSaved event, Emitter<ImportState> emit) {
    final draft = state.draft;
    if (draft == null) return;
    final exists = draft.rows.any((row) => row.key == event.row.key);
    final rows = exists
        ? [
            for (final row in draft.rows)
              row.key == event.row.key ? event.row : row,
          ]
        : ([...draft.rows, event.row]..sort((a, b) => a.stt.compareTo(b.stt)));
    emit(state.copyWith(draft: draft.withRows(rows)));
  }

  void _onRowDeleted(ImportRowDeleted event, Emitter<ImportState> emit) {
    final draft = state.draft;
    if (draft == null) return;
    final rows = draft.rows.where((row) => row.key != event.rowKey).toList();
    emit(state.copyWith(draft: draft.withRows(rows)));
  }

  Future<void> _onSavePressed(
    ImportSavePressed event,
    Emitter<ImportState> emit,
  ) async {
    final draft = state.draft;
    if (!state.canSave || draft == null) return;
    emit(state.copyWith(status: ImportStatus.saving));
    final ImportSummary summary;
    try {
      summary = await _save(draft);
    } catch (_) {
      emit(state.copyWith(status: ImportStatus.review));
      _emitEffect(const ShowImportMessage(AppStrings.importSaveFailed));
      return;
    }
    emit(state.copyWith(status: ImportStatus.saved));
    _emitEffect(ImportFinished(summary));
  }

  Future<void> _onCancelled(
    ImportCancelled event,
    Emitter<ImportState> emit,
  ) async {
    await _discardDraftFile();
    _emitEffect(const CloseImport());
  }

  /// Deletes the copied PDF of an unsaved draft.
  Future<void> _discardDraftFile() async {
    final draft = state.draft;
    if (draft == null || state.status == ImportStatus.saved) return;
    try {
      await _fileStore.delete(draft.sourceFilePath);
    } catch (_) {
      // Best effort: a leftover copy is removed by the later auto-cleanup.
    }
  }

  void _emitEffect(ImportEffect effect) {
    if (!_effects.isClosed) _effects.add(effect);
  }

  @override
  Future<void> close() async {
    // Leaving the flow by any route (e.g. system back) must not keep the copy.
    await _discardDraftFile();
    await _effects.close();
    return super.close();
  }
}
