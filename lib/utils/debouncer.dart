import 'dart:async';

import 'package:flutter/material.dart';

/// A class that helps to debounce actions.
class Debouncer {
  /// Creates an instance of [Debouncer].
  Debouncer({required this.milliseconds});

  /// The number of milliseconds to wait before running the action.
  final int milliseconds;

  /// The action to run.
  VoidCallback? action;

  Timer? _timer;

  /// Runs the action.
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
