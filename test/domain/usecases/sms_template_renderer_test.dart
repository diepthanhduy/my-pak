import 'package:assistant_pak/domain/entities/reminder_settings.dart';
import 'package:assistant_pak/domain/usecases/sms_template_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/call_task_fixtures.dart';

void main() {
  group('renderSmsReminder', () {
    test('fills the default template for a single patient', () {
      final task = fakeCallTask(
        date: DateTime(2026, 11, 2),
        patients: [fakePatient(name: 'Nguyễn Văn A', content: 'Tiêm cúm')],
      );

      final body = renderSmsReminder(
        template: defaultSmsTemplate,
        task: task,
        clinicName: 'ABC',
        clinicPhone: '0900000000',
      );

      expect(
        body,
        'Phòng khám ABC nhắc lịch: Nguyễn Văn A có lịch Tiêm cúm '
        'ngày 02/11/2026. Liên hệ 0900000000.',
      );
    });

    test('lists every name and distinct contents for a group', () {
      final task = fakeCallTask(
        patients: [
          fakePatient(stt: 1, name: 'Nguyễn Văn A', content: 'Tiêm cúm'),
          fakePatient(stt: 2, name: 'Nguyễn Thị B', content: 'Tiêm cúm'),
          fakePatient(stt: 3, name: 'Nguyễn Văn C', content: 'Tái khám'),
        ],
      );

      final body = renderSmsReminder(
        template: '{ten} | {noi_dung}',
        task: task,
        clinicName: 'ABC',
        clinicPhone: '0900000000',
      );

      expect(
        body,
        'Nguyễn Văn A, Nguyễn Thị B, Nguyễn Văn C | Tiêm cúm, Tái khám',
      );
    });

    test('leaves unknown placeholders untouched', () {
      final body = renderSmsReminder(
        template: '{ten} {khong_ro}',
        task: fakeCallTask(patients: [fakePatient(name: 'Trần Thị D')]),
        clinicName: 'ABC',
        clinicPhone: '0900000000',
      );

      expect(body, 'Trần Thị D {khong_ro}');
    });
  });
}
