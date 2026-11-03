part of 'import_bloc.dart';

sealed class ImportEffect extends Equatable {
  const ImportEffect();

  @override
  List<Object?> get props => [];
}

final class ShowReview extends ImportEffect {
  const ShowReview();
}

/// Leaves the flow without saving.
final class CloseImport extends ImportEffect {
  const CloseImport();
}

/// Saved: open Home on the list date and report [summary].
final class ImportFinished extends ImportEffect {
  const ImportFinished(this.summary);

  final ImportSummary summary;

  @override
  List<Object?> get props => [summary];
}

final class ShowImportMessage extends ImportEffect {
  const ShowImportMessage(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
