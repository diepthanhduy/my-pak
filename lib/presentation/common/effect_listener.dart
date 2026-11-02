import 'dart:async';

import 'package:flutter/widgets.dart';

/// Subscribes to a bloc's one-off effect stream for the lifetime of the widget.
class EffectListener<E> extends StatefulWidget {
  const EffectListener({
    super.key,
    required this.effects,
    required this.onEffect,
    required this.child,
  });

  final Stream<E> effects;
  final void Function(BuildContext context, E effect) onEffect;
  final Widget child;

  @override
  State<EffectListener<E>> createState() => _EffectListenerState<E>();
}

class _EffectListenerState<E> extends State<EffectListener<E>> {
  StreamSubscription<E>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(EffectListener<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.effects != widget.effects) {
      _subscription?.cancel();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _subscribe() {
    _subscription = widget.effects.listen((effect) {
      if (mounted) widget.onEffect(context, effect);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
