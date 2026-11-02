import 'package:assistant_pak/core/theme/app_theme.dart';
import 'package:assistant_pak/domain/entities/call_task.dart';
import 'package:assistant_pak/domain/entities/contact_summary.dart';
import 'package:assistant_pak/presentation/call_list/widgets/call_task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/call_task_fixtures.dart';

void main() {
  final today = DateTime(2026, 11, 2);

  final groupTask = fakeCallTask(
    phone: '0900123456',
    status: CallTaskStatus.retry,
    attemptCount: 2,
    lastContact: ContactSummary(
      channel: ContactChannel.call,
      at: DateTime(2026, 11, 2, 14, 32),
      result: ContactResult.noAnswer,
    ),
    patients: [
      fakePatient(stt: 1, name: 'Nguyễn Văn A', dob: DateTime(2021, 1, 1)),
      fakePatient(stt: 2, name: 'Nguyễn Thị B', dob: DateTime(2023, 6, 1)),
      fakePatient(stt: 3, name: 'Nguyễn Văn C', dob: DateTime(2026, 3, 1)),
    ],
  );

  Future<List<String>> pumpCard(WidgetTester tester, CallTask task) async {
    final taps = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: CallTaskCard(
            task: task,
            maxAttempts: 3,
            today: today,
            onTap: () => taps.add('card'),
            onCall: () => taps.add('call'),
            onSms: () => taps.add('sms'),
          ),
        ),
      ),
    );
    return taps;
  }

  testWidgets('renders a 3-patient group with chip, status and actions', (
    tester,
  ) async {
    await pumpCard(tester, groupTask);

    expect(find.text('0900 123 456'), findsOneWidget);
    expect(find.text('3 người'), findsOneWidget);
    expect(find.text('Lần 2/3'), findsOneWidget);
    expect(find.text('Gọi lại'), findsOneWidget);
    expect(find.text('Không nghe máy · 14:32'), findsOneWidget);
    expect(
      find.textContaining('Nguyễn Văn A · 5 tuổi', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Nguyễn Văn C · 8 tháng', findRichText: true),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Gọi'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'SMS'), findsOneWidget);
  });

  testWidgets('buttons and card tap trigger their own callbacks', (
    tester,
  ) async {
    final taps = await pumpCard(tester, groupTask);

    await tester.tap(find.widgetWithText(FilledButton, 'Gọi'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'SMS'));
    await tester.tap(find.text('0900 123 456'));

    expect(taps, ['call', 'sms', 'card']);
  });

  testWidgets('hides group chip and attempt counter for a fresh single task', (
    tester,
  ) async {
    await pumpCard(tester, fakeCallTask());

    expect(find.textContaining('người'), findsNothing);
    expect(find.textContaining('Lần'), findsNothing);
    expect(find.text('Chưa gọi'), findsOneWidget);
  });
}
