import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/usecases/call_task_sorting.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/call_task_fixtures.dart';

void main() {
  group('sortCallTasks', () {
    test('orders by status: pending, retry, done, unreachable', () {
      final tasks = [
        fakeCallTask(id: 1, status: CallTaskStatus.unreachable),
        fakeCallTask(id: 2, status: CallTaskStatus.done),
        fakeCallTask(id: 3, status: CallTaskStatus.retry),
        fakeCallTask(id: 4, status: CallTaskStatus.pending),
      ];

      expect(sortCallTasks(tasks).map((t) => t.id), [4, 3, 2, 1]);
    });

    test('orders retry tasks by earliest nextRetryAt, nulls last', () {
      final tasks = [
        fakeCallTask(id: 1, status: CallTaskStatus.retry),
        fakeCallTask(
          id: 2,
          status: CallTaskStatus.retry,
          nextRetryAt: DateTime(2026, 11, 2, 15),
        ),
        fakeCallTask(
          id: 3,
          status: CallTaskStatus.retry,
          nextRetryAt: DateTime(2026, 11, 2, 11),
        ),
      ];

      expect(sortCallTasks(tasks).map((t) => t.id), [3, 2, 1]);
    });

    test('keeps PDF order (STT) within the same status', () {
      final tasks = [
        fakeCallTask(id: 1, patients: [fakePatient(stt: 7)]),
        fakeCallTask(
          id: 2,
          patients: [fakePatient(stt: 5), fakePatient(stt: 2)],
        ),
        fakeCallTask(id: 3, patients: [fakePatient(stt: 4)]),
      ];

      expect(sortCallTasks(tasks).map((t) => t.id), [2, 3, 1]);
    });

    test('sorts patients inside a group by STT', () {
      final task = fakeCallTask(
        patients: [fakePatient(stt: 3), fakePatient(stt: 1), fakePatient()],
      );

      expect(sortCallTasks([task]).single.patients.map((p) => p.stt), [
        1,
        1,
        3,
      ]);
    });
  });
}
