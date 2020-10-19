import 'dart:async';

/**
 * 
 */
class Clock extends _Ticker {
  int _minutes = 0;
  int _seconds = 0;
  int _hours = 0;
  bool _status = false; //false == stopped, true = running

  Duration _duration;

  Clock(this._duration) : super(_duration);

  Stream<int> start() {
    _status = true;
    return super.start();
  }

  void pause(StreamSubscription streamSubscription) {
    _status = false;
    streamSubscription.pause();
  }
  
  void stop(StreamSubscription streamSubscription) {
    _status = false;
    streamSubscription.cancel();
  }

  void reset() {
    _hours = 0;
    _seconds = 0;
    _minutes = 0;
  }

  void addSecond() {
    if (_minutes >= 59) {
      _hours++;
      _minutes = 0;
    }
    if (_seconds >= 59) {
      _minutes++;
      _seconds = 0;
    } else {
      _seconds++;
    }
  }

  int get minutes {return _minutes; }
  int get seconds {return _seconds; }
  int get hours {return _hours; }
  bool get status {return _status; }
}

/**
 * Questa è la classe che gestisce i tick per la classe Clock.
 */
class _Ticker {
  Duration duration;
  static Stream<int> _stream;

  _Ticker(this.duration);

  Stream<int> start() {
    //if (_stream == null) {
      _stream = timedCounter(duration);
    //}
    return _stream;
  }

  Stream<int> timedCounter(Duration interval) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
    }
  }
}
