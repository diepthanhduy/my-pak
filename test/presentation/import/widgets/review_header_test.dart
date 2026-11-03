import 'package:assistant_pak/domain/entities/import_draft.dart';
import 'package:assistant_pak/domain/entities/import_warning.dart';
import 'package:assistant_pak/presentation/import/widgets/review_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/import_fixtures.dart';

void main() {
  Future<Text> pumpCount(WidgetTester tester, ImportDraft draft) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ReviewHeader(draft: draft)),
      ),
    );
    return tester.widget<Text>(find.byKey(const ValueKey('review-count')));
  }

  testWidgets('shows date, clinic, counts and phone groups', (tester) async {
    final draft = fakeImportDraft(
      rows: [
        fakeImportRow(key: 1),
        fakeImportRow(key: 2, phoneText: '0900000002'),
      ],
    );

    final count = await pumpCount(tester, draft);

    expect(find.text('Ngày tái khám: 15/12/2025'), findsOneWidget);
    expect(
      find.text('Phòng khám: Phòng khám ABC · 0280 000 0001'),
      findsOneWidget,
    );
    expect(count.data, 'Đã đọc 2 / Tổng cộng 2');
    expect(
      count.style?.color,
      isNot(
        Theme.of(tester.element(find.byType(ReviewHeader))).colorScheme.error,
      ),
    );
    expect(find.text('2 số điện thoại'), findsOneWidget);
  });

  testWidgets('shows a count mismatch in red', (tester) async {
    final base = fakeImportDraft(expectedCount: 3);
    final draft = ImportDraft(
      sourceFilePath: base.sourceFilePath,
      parsedCount: base.parsedCount,
      rows: base.rows,
      listDate: base.listDate,
      expectedCount: 3,
      fileWarnings: const {ImportWarningType.countMismatch},
    );

    final count = await pumpCount(tester, draft);
    final error = Theme.of(
      tester.element(find.byType(ReviewHeader)),
    ).colorScheme.error;

    expect(count.data, 'Đã đọc 1 / Tổng cộng 3');
    expect(count.style?.color, error);
  });

  testWidgets('shows a missing total in red', (tester) async {
    final base = fakeImportDraft();
    final draft = ImportDraft(
      sourceFilePath: base.sourceFilePath,
      parsedCount: 1,
      rows: base.rows,
      fileWarnings: const {ImportWarningType.missingTotal},
    );

    final count = await pumpCount(tester, draft);

    expect(count.data, 'Đã đọc 1 · không thấy dòng Tổng cộng');
    expect(find.text('Ngày tái khám: chưa rõ'), findsOneWidget);
    expect(
      count.style?.color,
      Theme.of(tester.element(find.byType(ReviewHeader))).colorScheme.error,
    );
  });
}
