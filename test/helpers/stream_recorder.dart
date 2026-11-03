import 'dart:async';

/// Buffers every emission of a stream so tests can await them one by one
/// without racing the first emission.
final class StreamRecorder<T> {
  StreamRecorder(Stream<T> stream) {
    _subscription = stream.listen((value) {
      _values.add(value);
      _waiter?.complete();
      _waiter = null;
    });
  }

  late final StreamSubscription<T> _subscription;
  final _values = <T>[];
  var _read = 0;
  Completer<void>? _waiter;

  /// The next emission not returned yet, waiting for it if needed.
  Future<T> next() async {
    while (_read >= _values.length) {
      await (_waiter ??= Completer<void>()).future.timeout(
        const Duration(seconds: 2),
      );
    }
    return _values[_read++];
  }

  /// Skips emissions until one satisfies [test]. Drift may re-emit an
  /// unchanged result after an unrelated write.
  Future<T> nextWhere(bool Function(T value) test) async {
    while (true) {
      final value = await next();
      if (test(value)) return value;
    }
  }

  Future<void> cancel() => _subscription.cancel();
}
