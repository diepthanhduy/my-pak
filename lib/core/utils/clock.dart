import 'package:injectable/injectable.dart';

/// Wall-clock abstraction so time-dependent logic can be tested.
@lazySingleton
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
