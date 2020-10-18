class Clock {
  int _minutes;
  int _seconds;
  int _hours;
  bool _status = false; //false == stopped, true = running

  Duration duration;

  Stream<int> _stream;

  Clock(this.duration);

  Stream<int> start() {
    _status = true;
    _stream = timedCounter(duration);
    return _stream;
  }

  void stop() {
    _status = false;
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

  Stream<int> timedCounter(Duration interval) async* {
    int i = 0;
    while (true) {
      print(i);
      await Future.delayed(interval);
      yield i++;
    }
  }

  int get minutes => _minutes;
  int get seconds => _seconds;
  int get hours => _hours;
  bool get status => _status;
}

class _Ticker {
  Duration duration;
  Stream<int> _stream;

  Ticker(this.duration);

  Stream<int> start() {
    _stream = timedCounter(duration);
    return _stream;
  }

  void stop() {
    _stream.
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
