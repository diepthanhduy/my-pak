import 'package:drift/drift.dart';

import '../../../domain/entities/import_source_type.dart';

@DataClassName('ImportBatchRow')
@TableIndex(name: 'import_batches_date', columns: {#date})
class ImportBatches extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Day only (local midnight).
  DateTimeColumn get date => dateTime()();
  TextColumn get sourceType => textEnum<ImportSourceType>()();

  /// Copy of the source file in app storage; null once auto-deleted.
  TextColumn get sourceFilePath => text().nullable()();

  /// `Tổng Cộng : N` printed in the PDF footer, if found.
  IntColumn get expectedCount => integer().nullable()();
  IntColumn get parsedCount => integer()();
  DateTimeColumn get createdAt => dateTime()();
}
