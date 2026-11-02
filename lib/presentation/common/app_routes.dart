/// Route locations, shared by the router and navigation effects.
abstract final class AppRoutes {
  static const home = '/';
  static const importPdf = '/import';
  static const settings = '/settings';
  static const callTaskPattern = '/call-task/:id';

  static String callTask(int id) => '/call-task/$id';
}
