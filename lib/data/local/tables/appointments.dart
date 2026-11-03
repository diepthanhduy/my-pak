import 'package:drift/drift.dart';

import '../../../domain/entities/appointment_status.dart';
import 'call_tasks.dart';
import 'import_batches.dart';
import 'patients.dart';

@DataClassName('AppointmentRow')
@TableIndex(name: 'appointments_call_task_id', columns: {#callTaskId})
@TableIndex(name: 'appointments_date', columns: {#date})
class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Patients, #id)();

  /// Null when the patient is not called, e.g. the row carries the clinic
  /// phone.
  IntColumn get callTaskId => integer().nullable().references(CallTasks, #id)();
  IntColumn get importBatchId => integer().nullable().references(
    ImportBatches,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Day only (local midnight).
  DateTimeColumn get date => dateTime()();

  /// Row number (STT) in the source PDF.
  IntColumn get stt => integer()();

  /// Nội Dung.
  TextColumn get content => text()();
  TextColumn get status => textEnum<AppointmentStatus>().withDefault(
    Constant(AppointmentStatus.pending.name),
  )();

  @override
  List<Set<Column>> get uniqueKeys => [
    {patientId, date},
  ];
}
