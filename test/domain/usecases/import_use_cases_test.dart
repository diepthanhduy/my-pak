import 'package:assistant_pak/domain/entities/import_summary.dart';
import 'package:assistant_pak/domain/repositories/import_repository.dart';
import 'package:assistant_pak/domain/services/import_file_store.dart';
import 'package:assistant_pak/domain/usecases/parse_appointment_pdf.dart';
import 'package:assistant_pak/domain/usecases/save_import_batch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/import_fixtures.dart';

class _MockRepository extends Mock implements ImportRepository {}

class _MockFileStore extends Mock implements ImportFileStore {}

void main() {
  late _MockRepository repository;
  late _MockFileStore fileStore;

  setUpAll(() => registerFallbackValue(fakeImportDraft()));

  setUp(() {
    repository = _MockRepository();
    fileStore = _MockFileStore();
    when(() => fileStore.copyIn(any())).thenAnswer((_) async => '/copy.pdf');
    when(() => fileStore.delete(any())).thenAnswer((_) async {});
  });

  group('ParseAppointmentPdf', () {
    test('parses the stored copy', () async {
      final draft = fakeImportDraft(sourceFilePath: '/copy.pdf');
      when(() => repository.parse('/copy.pdf')).thenAnswer((_) async => draft);

      final result = await ParseAppointmentPdf(repository, fileStore)(
        '/picked.pdf',
      );

      expect(result, draft);
      verify(() => fileStore.copyIn('/picked.pdf')).called(1);
      verifyNever(() => fileStore.delete(any()));
    });

    test('deletes the copy when parsing fails', () async {
      when(() => repository.parse(any())).thenThrow(Exception('broken'));

      await expectLater(
        ParseAppointmentPdf(repository, fileStore)('/picked.pdf'),
        throwsException,
      );
      verify(() => fileStore.delete('/copy.pdf')).called(1);
    });
  });

  group('SaveImportBatch', () {
    test('saves a valid draft', () async {
      final summary = ImportSummary(
        listDate: DateTime(2025, 12, 15),
        newAppointments: 1,
        existingAppointments: 0,
        callTaskCount: 1,
      );
      when(() => repository.save(any())).thenAnswer((_) async => summary);

      expect(await SaveImportBatch(repository)(fakeImportDraft()), summary);
    });

    test('refuses a draft with blocking rows', () {
      final draft = fakeImportDraft(rows: [fakeImportRow(phoneText: '')]);

      expect(() => SaveImportBatch(repository)(draft), throwsArgumentError);
      verifyNever(() => repository.save(any()));
    });
  });
}
