import 'dart:async';

class DeBouncer {
  final int milliseconds;
  Function()? action;
  Timer? _timer;

  DeBouncer({required this.milliseconds});

  void run(Function() action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }
}