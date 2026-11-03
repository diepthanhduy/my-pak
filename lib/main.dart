import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pdfrx/pdfrx.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'data/local/dev_data_seeder.dart';

/// `--dart-define=ENV=dev` uses in-memory fake data; `prod` (default) drift.
const _environment = String.fromEnvironment(
  'ENV',
  defaultValue: Environment.prod,
);

/// `--dart-define=SEED=true` fills an empty prod database in debug builds.
const _seed = bool.fromEnvironment('SEED');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_environment != Environment.dev && _environment != Environment.prod) {
    throw ArgumentError.value(_environment, 'ENV', 'Expected dev or prod');
  }
  // PDF documents are opened before any pdfrx widget is built.
  await pdfrxFlutterInitialize();
  await configureDependencies(environment: _environment);
  if (kDebugMode && _seed && _environment == Environment.prod) {
    await getIt<DevDataSeeder>().seedIfEmpty();
  }
  runApp(const AssistantApp());
}
