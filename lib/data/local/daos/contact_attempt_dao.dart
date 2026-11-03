import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/contact_attempts.dart';

part 'contact_attempt_dao.g.dart';

@DriftAccessor(tables: [ContactAttempts])
class ContactAttemptDao extends DatabaseAccessor<AppDatabase>
    with _$ContactAttemptDaoMixin {
  ContactAttemptDao(super.attachedDatabase);

  Future<int> insertAttempt(ContactAttemptsCompanion attempt) =>
      into(contactAttempts).insert(attempt);

  /// Attempts of [callTaskId], newest first.
  Future<List<ContactAttemptRow>> attemptsForTask(int callTaskId) =>
      (select(contactAttempts)
            ..where((a) => a.callTaskId.equals(callTaskId))
            ..orderBy([
              (a) => OrderingTerm.desc(a.startedAt),
              (a) => OrderingTerm.desc(a.id),
            ]))
          .get();
}
