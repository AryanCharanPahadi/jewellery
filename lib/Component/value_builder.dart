
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A generic builder widget that listens to two `ValueNotifier`s and rebuilds
/// its widget tree when either of the notifiers changes.
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(
      BuildContext context, A firstValue, B secondValue, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, firstValue, child) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, secondValue, child) {
            return builder(context, firstValue, secondValue, this.child);
          },
        );
      },
    );
  }
}
