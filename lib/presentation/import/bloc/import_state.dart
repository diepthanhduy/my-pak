part of 'import_bloc.dart';

enum ImportStatus { picking, parsing, review, saving, saved, failure }

enum ImportFailure { unreadable, noRows }

final class ImportState extends Equatable {
  const ImportState({
    this.status = ImportStatus.picking,
    this.draft,
    this.warningFilter,
    this.failure,
  });

  final ImportStatus status;
  final ImportDraft? draft;
  final ImportWarningType? warningFilter;
  final ImportFailure? failure;

  List<ImportRow> get rows => draft?.rows ?? const [];

  List<ImportRow> get visibleRows {
    final filter = warningFilter;
    if (filter == null) return rows;
    return rows.where((row) => row.allWarnings.contains(filter)).toList();
  }

  /// Rows per warning type, for the warning banner.
  Map<ImportWarningType, int> get rowWarningCounts {
    final counts = <ImportWarningType, int>{};
    for (final row in rows) {
      for (final type in row.allWarnings) {
        counts[type] = (counts[type] ?? 0) + 1;
      }
    }
    return counts;
  }

  int get blockingCount => rows.where((row) => row.isBlocking).length;

  bool get canSave =>
      status == ImportStatus.review && (draft?.canSave ?? false);

  ImportState copyWith({
    ImportStatus? status,
    ImportDraft? draft,
    ImportWarningType? warningFilter,
    bool clearWarningFilter = false,
    ImportFailure? failure,
    bool clearFailure = false,
  }) => ImportState(
    status: status ?? this.status,
    draft: draft ?? this.draft,
    warningFilter: clearWarningFilter
        ? null
        : warningFilter ?? this.warningFilter,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, draft, warningFilter, failure];
}
