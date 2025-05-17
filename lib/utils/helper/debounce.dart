// implementation from https://dev.to/alaminkarno/from-chaos-to-control-the-day-i-learned-the-magic-of-debouncing-in-flutter-63k

import 'dart:async';
import 'dart:ui';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    // Cancel the previous timer if it's still active
    _timer?.cancel();

    // Start a new timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
