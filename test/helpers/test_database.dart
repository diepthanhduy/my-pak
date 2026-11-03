import 'package:assistant_pak/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Fresh in-memory database; close it in `tearDown`.
AppDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

/// Inserts a patient with an appointment on [callTaskId]'s day.
/// Synthetic data only. Returns the appointment id.
Future<int> insertPatientAppointment(
  AppDatabase db, {
  required int callTaskId,
  required DateTime date,
  required String medicalCode,
  String name = 'Nguyễn Văn A',
  String phone = '0900000001',
  int stt = 1,
  String content = 'Tiêm vắc xin cúm',
}) async {
  final patientId = await db.importDao.upsertPatient(
    PatientsCompanion.insert(
      medicalCode: medicalCode,
      name: name,
      phoneNormalized: phone,
    ),
  );
  return db
      .into(db.appointments)
      .insert(
        AppointmentsCompanion.insert(
          patientId: patientId,
          callTaskId: Value(callTaskId),
          date: date,
          stt: stt,
          content: content,
        ),
      );
}
