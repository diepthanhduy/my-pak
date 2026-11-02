import 'package:assistant_pak/app/app.dart';
import 'package:assistant_pak/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  setUp(() => configureDependencies(environment: Environment.dev));
  tearDown(getIt.reset);

  testWidgets('App opens on Home with today\'s synthetic list', (tester) async {
    await tester.pumpWidget(const AssistantApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Hôm nay'), findsOneWidget);
    expect(find.textContaining('Đã liên hệ'), findsOneWidget);
    expect(find.text('Import PDF'), findsOneWidget);
  });
}
