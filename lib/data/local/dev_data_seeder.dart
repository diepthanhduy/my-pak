import 'package:injectable/injectable.dart';

import '../../core/utils/clock.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/call_task.dart';
import '../repositories/synthetic_call_tasks.dart';
import 'app_database.dart';
import 'mappers/call_task_mapper.dart';

/// Debug helper: fills an empty database with SYNTHETIC call tasks so the prod
/// environment can be tested by hand. Run with `--dart-define=SEED=true`.
@Injectable(env: [Environment.prod])
class DevDataSeeder {
  const DevDataSeeder(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  /// Returns false and writes nothing when call tasks already exist.
  Future<bool> seedIfEmpty() => _db.transaction(() async {
    if (await _db.callTaskDao.countCallTasks() > 0) return false;
    final tasks = buildSyntheticCallTasks(dateOnly(_clock.now()));
    for (final task in tasks) {
      await _insert(task);
    }
    return true;
  });

  Future<void> _insert(CallTask task) async {
    await _db.into(_db.callTasks).insert(task.toCompanion());
    for (final patient in task.patients) {
      final patientId = await _db.importDao.upsertPatient(
        patient.toPatientCompanion(phoneNormalized: task.phoneNormalized),
      );
      await _db
          .into(_db.appointments)
          .insert(
            patient.toAppointmentCompanion(
              patientId: patientId,
              callTaskId: task.id,
              date: task.date,
            ),
          );
    }
    final lastContact = task.lastContact;
    if (lastContact != null) {
      await _db.contactAttemptDao.insertAttempt(
        lastContact.toCompanion(callTaskId: task.id),
      );
    }
  }
}
