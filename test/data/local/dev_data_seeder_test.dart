import 'package:assistant_pak/core/utils/clock.dart';
import 'package:assistant_pak/data/local/app_database.dart';
import 'package:assistant_pak/data/local/dev_data_seeder.dart';
import 'package:assistant_pak/data/local/mappers/call_task_mapper.dart';
import 'package:assistant_pak/data/repositories/synthetic_call_tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_database.dart';

class _MockClock extends Mock implements Clock {}

void main() {
  late AppDatabase db;
  late DevDataSeeder seeder;
  final today = DateTime(2026, 11, 3);

  setUp(() {
    db = openTestDatabase();
    final clock = _MockClock();
    when(clock.now).thenReturn(DateTime(2026, 11, 3, 8));
    seeder = DevDataSeeder(db, clock);
  });
  tearDown(() => db.close());

  test('fills an empty database with the synthetic list', () async {
    expect(await seeder.seedIfEmpty(), isTrue);

    final expected = buildSyntheticCallTasks(
      today,
    ).where((task) => task.date == today).toList();
    final stored = await db.callTaskDao.watchByDate(today).first;
    expect(stored.map((row) => row.toEntity()).toList(), expected);
  });

  test('does nothing when call tasks already exist', () async {
    await seeder.seedIfEmpty();
    final count = await db.callTaskDao.countCallTasks();

    expect(await seeder.seedIfEmpty(), isFalse);
    expect(await db.callTaskDao.countCallTasks(), count);
  });
}
