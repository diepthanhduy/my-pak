import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app/app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fake in-memory repositories until the drift implementation lands.
  await configureDependencies(environment: Environment.dev);
  runApp(const AssistantApp());
}
