import 'package:assistant_pak/domain/entities/import_summary.dart';
import 'package:assistant_pak/domain/entities/import_warning.dart';
import 'package:assistant_pak/domain/services/import_file_store.dart';
import 'package:assistant_pak/domain/services/pdf_picker.dart';
import 'package:assistant_pak/domain/usecases/parse_appointment_pdf.dart';
import 'package:assistant_pak/domain/usecases/save_import_batch.dart';
import 'package:assistant_pak/presentation/common/app_strings.dart';
import 'package:assistant_pak/presentation/import/bloc/import_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/import_fixtures.dart';

class _MockPicker extends Mock implements PdfPicker {}

class _MockParse extends Mock implements ParseAppointmentPdf {}

class _MockSave extends Mock implements SaveImportBatch {}

class _MockFileStore extends Mock implements ImportFileStore {}

void main() {
  late _MockPicker picker;
  late _MockParse parse;
  late _MockSave save;
  late _MockFileStore fileStore;
  late List<ImportEffect> effects;

  final draft = fakeImportDraft(
    rows: [
      fakeImportRow(key: 1),
      fakeImportRow(key: 2, phoneText: '0900000002'),
    ],
  );
  final summary = ImportSummary(
    listDate: DateTime(2025, 12, 15),
    newAppointments: 2,
    existingAppointments: 0,
    callTaskCount: 2,
  );
  final reviewState = ImportState(status: ImportStatus.review, draft: draft);

  setUpAll(() => registerFallbackValue(draft));

  setUp(() {
    picker = _MockPicker();
    parse = _MockParse();
    save = _MockSave();
    fileStore = _MockFileStore();
    effects = [];
    when(() => picker.pickPdf()).thenAnswer((_) async => '/picked.pdf');
    when(() => picker.clearTemporaryFiles()).thenAnswer((_) async {});
    when(() => parse(any())).thenAnswer((_) async => draft);
    when(() => save(any())).thenAnswer((_) async => summary);
    when(() => fileStore.delete(any())).thenAnswer((_) async {});
  });

  ImportBloc buildBloc() {
    final bloc = ImportBloc(picker, parse, save, fileStore);
    bloc.effects.listen(effects.add);
    return bloc;
  }

  group('ImportStarted', () {
    blocTest<ImportBloc, ImportState>(
      'picks, parses and opens the review',
      build: buildBloc,
      act: (bloc) => bloc.add(const ImportStarted()),
      expect: () => [
        const ImportState(status: ImportStatus.parsing),
        reviewState,
      ],
      verify: (_) {
        verify(() => parse('/picked.pdf')).called(1);
        verify(() => picker.clearTemporaryFiles()).called(1);
        expect(effects, [const ShowReview()]);
      },
    );

    blocTest<ImportBloc, ImportState>(
      'parses a shared PDF without opening the picker',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const ImportStarted(sharedFilePath: '/shared.pdf')),
      expect: () => [
        const ImportState(status: ImportStatus.parsing),
        reviewState,
      ],
      verify: (_) {
        verifyNever(() => picker.pickPdf());
        verify(() => parse('/shared.pdf')).called(1);
      },
    );

    blocTest<ImportBloc, ImportState>(
      'closes the flow when the picker is cancelled',
      setUp: () => when(() => picker.pickPdf()).thenAnswer((_) async => null),
      build: buildBloc,
      act: (bloc) => bloc.add(const ImportStarted()),
      expect: () => const <ImportState>[],
      verify: (_) {
        verifyNever(() => parse(any()));
        expect(effects, [const CloseImport()]);
      },
    );

    blocTest<ImportBloc, ImportState>(
      'reports an unreadable PDF',
      setUp: () => when(() => parse(any())).thenThrow(Exception('broken')),
      build: buildBloc,
      act: (bloc) => bloc.add(const ImportStarted()),
      expect: () => [
        const ImportState(status: ImportStatus.parsing),
        const ImportState(
          status: ImportStatus.failure,
          failure: ImportFailure.unreadable,
        ),
      ],
    );

    blocTest<ImportBloc, ImportState>(
      'reports a PDF without rows and deletes its copy',
      setUp: () => when(
        () => parse(any()),
      ).thenAnswer((_) async => fakeImportDraft(rows: [])),
      build: buildBloc,
      act: (bloc) => bloc.add(const ImportStarted()),
      expect: () => [
        const ImportState(status: ImportStatus.parsing),
        const ImportState(
          status: ImportStatus.failure,
          failure: ImportFailure.noRows,
        ),
      ],
      verify: (_) =>
          verify(() => fileStore.delete('/tmp/imports/1.pdf')).called(1),
    );
  });

  group('review edits', () {
    blocTest<ImportBloc, ImportState>(
      'editing a row revalidates it and blocks saving',
      build: buildBloc,
      seed: () => reviewState,
      act: (bloc) =>
          bloc.add(ImportRowSaved(draft.rows.first.copyWith(phoneText: 'abc'))),
      verify: (bloc) {
        expect(bloc.state.rows.first.warnings, {
          ImportWarningType.invalidPhone,
        });
        expect(bloc.state.blockingCount, 1);
        expect(bloc.state.canSave, isFalse);
      },
    );

    blocTest<ImportBloc, ImportState>(
      'deleting the blocking row allows saving again',
      build: buildBloc,
      seed: () => reviewState.copyWith(
        draft: draft.withRows([
          ...draft.rows,
          fakeImportRow(key: 3, phoneText: ''),
        ]),
      ),
      act: (bloc) => bloc.add(const ImportRowDeleted(3)),
      verify: (bloc) {
        expect(bloc.state.rows.map((r) => r.key), [1, 2]);
        expect(bloc.state.canSave, isTrue);
      },
    );

    blocTest<ImportBloc, ImportState>(
      'adding a row keeps rows ordered by STT',
      build: buildBloc,
      seed: () => reviewState,
      act: (bloc) => bloc
        ..add(const ImportRowDeleted(1))
        ..add(ImportRowSaved(draft.rows.first)),
      verify: (bloc) => expect(bloc.state.rows.map((r) => r.key), [1, 2]),
    );

    blocTest<ImportBloc, ImportState>(
      'warning filter shows only affected rows',
      build: buildBloc,
      seed: () => reviewState.copyWith(
        draft: draft.withRows([
          ...draft.rows,
          fakeImportRow(key: 3, dobText: 'x'),
        ]),
      ),
      act: (bloc) => bloc
        ..add(const ImportWarningFilterChanged(ImportWarningType.invalidDate))
        ..add(const ImportWarningFilterChanged(null)),
      expect: () => [
        isA<ImportState>().having(
          (s) => s.visibleRows.map((r) => r.key),
          'visible keys',
          [3],
        ),
        isA<ImportState>().having(
          (s) => s.visibleRows,
          'visible',
          hasLength(3),
        ),
      ],
    );
  });

  group('save', () {
    blocTest<ImportBloc, ImportState>(
      'saves and finishes with the summary',
      build: buildBloc,
      seed: () => reviewState,
      act: (bloc) => bloc.add(const ImportSavePressed()),
      expect: () => [
        reviewState.copyWith(status: ImportStatus.saving),
        reviewState.copyWith(status: ImportStatus.saved),
      ],
      verify: (_) {
        verify(() => save(draft)).called(1);
        expect(effects, [ImportFinished(summary)]);
        verifyNever(() => fileStore.delete(any()));
      },
    );

    blocTest<ImportBloc, ImportState>(
      'returns to review with a message when saving fails',
      setUp: () => when(() => save(any())).thenThrow(Exception('db')),
      build: buildBloc,
      seed: () => reviewState,
      act: (bloc) => bloc.add(const ImportSavePressed()),
      expect: () => [
        reviewState.copyWith(status: ImportStatus.saving),
        reviewState,
      ],
      verify: (_) => expect(effects, [
        const ShowImportMessage(AppStrings.importSaveFailed),
      ]),
    );

    blocTest<ImportBloc, ImportState>(
      'ignores save while a row blocks it',
      build: buildBloc,
      seed: () => reviewState.copyWith(
        draft: draft.withRows([fakeImportRow(phoneText: '')]),
      ),
      act: (bloc) => bloc.add(const ImportSavePressed()),
      expect: () => const <ImportState>[],
      verify: (_) => verifyNever(() => save(any())),
    );
  });

  group('cancel', () {
    blocTest<ImportBloc, ImportState>(
      'deletes the copied PDF and closes the flow',
      build: buildBloc,
      seed: () => reviewState,
      act: (bloc) => bloc.add(const ImportCancelled()),
      verify: (_) {
        verify(
          () => fileStore.delete('/tmp/imports/1.pdf'),
        ).called(greaterThan(0));
        expect(effects, [const CloseImport()]);
        verifyNever(() => save(any()));
      },
    );

    test('closing the bloc with an unsaved draft deletes the copy', () async {
      final bloc = buildBloc()..emit(reviewState);
      await bloc.close();
      verify(() => fileStore.delete('/tmp/imports/1.pdf')).called(1);
    });
  });
}
