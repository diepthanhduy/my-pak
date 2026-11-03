import 'package:drift/drift.dart';

@DataClassName('PatientRow')
class Patients extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Mã Y Tế; re-imports upsert patients by it.
  TextColumn get medicalCode => text().unique()();
  TextColumn get name => text()();
  DateTimeColumn get dob => dateTime().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phoneNormalized => text()();
}
