import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../data/local/app_database.dart';

@module
abstract class DatabaseModule {
  /// The single place the database is opened (swap in SQLCipher here).
  @LazySingleton(env: [Environment.prod], dispose: closeAppDatabase)
  AppDatabase get database => AppDatabase(driftDatabase(name: 'assistant_pak'));
}

Future<void> closeAppDatabase(AppDatabase database) => database.close();
