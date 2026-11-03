import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/theme/app_theme.dart';
import '../domain/services/shared_pdf_source.dart';
import '../presentation/common/app_routes.dart';
import '../presentation/common/app_strings.dart';
import 'router.dart';

class AssistantApp extends StatefulWidget {
  const AssistantApp({super.key});

  @override
  State<AssistantApp> createState() => _AssistantAppState();
}

class _AssistantAppState extends State<AssistantApp> {
  late final GoRouter _router = createRouter();
  final _sharedPdfs = getIt<SharedPdfSource>();
  StreamSubscription<String>? _sharedSubscription;

  @override
  void initState() {
    super.initState();
    _sharedSubscription = _sharedPdfs.sharedPdfs.listen(_openImport);
    _sharedPdfs.takeInitialPdf().then((path) {
      if (path != null && mounted) _openImport(path);
    });
  }

  /// Starts the import flow with a PDF from another app, unless an import is
  /// already in progress.
  void _openImport(String path) {
    final location = _router.routerDelegate.currentConfiguration.uri.path;
    if (location.startsWith(AppRoutes.importPdf)) return;
    _router.push(AppRoutes.importPdf, extra: path);
  }

  @override
  void dispose() {
    _sharedSubscription?.cancel();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: AppStrings.appTitle,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    locale: const Locale('vi'),
    supportedLocales: const [Locale('vi')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    routerConfig: _router,
  );
}
