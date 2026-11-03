part of 'import_bloc.dart';

sealed class ImportEvent extends Equatable {
  const ImportEvent();

  @override
  List<Object?> get props => [];
}

/// Opens the flow: parses [sharedFilePath] when the PDF came from another
/// app, otherwise opens the file picker.
final class ImportStarted extends ImportEvent {
  const ImportStarted({this.sharedFilePath});

  final String? sharedFilePath;

  @override
  List<Object?> get props => [sharedFilePath];
}

final class ImportPickPressed extends ImportEvent {
  const ImportPickPressed();
}

/// Adds [row], or replaces the row with the same key.
final class ImportRowSaved extends ImportEvent {
  const ImportRowSaved(this.row);

  final ImportRow row;

  @override
  List<Object?> get props => [row];
}

final class ImportRowDeleted extends ImportEvent {
  const ImportRowDeleted(this.rowKey);

  final int rowKey;

  @override
  List<Object?> get props => [rowKey];
}

/// Shows only rows with [type]; null shows all rows.
final class ImportWarningFilterChanged extends ImportEvent {
  const ImportWarningFilterChanged(this.type);

  final ImportWarningType? type;

  @override
  List<Object?> get props => [type];
}

final class ImportSavePressed extends ImportEvent {
  const ImportSavePressed();
}

/// Leaves the flow without saving; the copied PDF is deleted.
final class ImportCancelled extends ImportEvent {
  const ImportCancelled();
}
