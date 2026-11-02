import 'package:go_router/go_router.dart';

import '../presentation/call_list/call_task_page.dart';
import '../presentation/call_list/home_page.dart';
import '../presentation/common/app_routes.dart';
import '../presentation/import/import_page.dart';
import '../presentation/settings/settings_page.dart';

GoRouter createRouter() => GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
    GoRoute(path: AppRoutes.importPdf, builder: (_, _) => const ImportPage()),
    GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsPage()),
    GoRoute(
      path: AppRoutes.callTaskPattern,
      builder: (_, state) => CallTaskPage(
        callTaskId: int.tryParse(state.pathParameters['id'] ?? ''),
      ),
    ),
  ],
);
