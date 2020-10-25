import 'dart:async';

/**
 * Questa è la classe che gestisce i tick per la classe Clock.
 */
class _Ticker {
  Duration duration;
  Stream<int> _stream;

  _Ticker(this.duration);

  Stream<int> start() {
    //if (_stream == null) {
    _stream = timedCounter(duration);
    //}
    return _stream;
  }

  void stop(StreamSubscription streamSubscription) {
    streamSubscription.cancel();
  }

  Stream<int> timedCounter(Duration interval) async* {
    int i = 0;
    while (true) {
      print(i);
      await Future.delayed(interval);
      yield i++;
    }
  }
}
