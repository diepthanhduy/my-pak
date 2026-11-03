import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/date_utils.dart';
import '../presentation/call_list/call_task_page.dart';
import '../presentation/call_list/home_page.dart';
import '../presentation/common/app_routes.dart';
import '../presentation/import/import_flow.dart';
import '../presentation/import/import_page.dart';
import '../presentation/import/import_review_page.dart';
import '../presentation/settings/settings_page.dart';

GoRouter createRouter() => GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (_, state) {
        final date = parseIsoDate(state.uri.queryParameters['date']);
        // A new key per date rebuilds Home (and its bloc) on that day.
        return HomePage(key: ValueKey(date), initialDate: date);
      },
    ),
    ShellRoute(
      builder: (_, _, child) => ImportFlow(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.importPdf,
          builder: (_, state) =>
              ImportPage(sharedFilePath: state.extra as String?),
          routes: [
            GoRoute(
              path: 'review',
              builder: (_, _) => const ImportReviewPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsPage()),
    GoRoute(
      path: AppRoutes.callTaskPattern,
      builder: (_, state) => CallTaskPage(
        callTaskId: int.tryParse(state.pathParameters['id'] ?? ''),
      ),
    ),
  ],
);
