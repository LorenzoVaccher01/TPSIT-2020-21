import 'dart:async';

import 'ticker.dart';
import 'laps.dart';

/**
 * 
 */
class Clock extends Ticker {
  int _minutes = 0;
  int _seconds = 0;
  int _hours = 0;
  final Duration _duration;
  final bool _reverse;

  bool _status = false; //false == stopped, true = running

  Laps _laps = new Laps<Lap>();

  Clock(this._duration, this._reverse) : super(_duration);

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
    resetLaps();
  }

  void addSecond() {
    if (_reverse) {
      if (_seconds == 0) {
        if (_minutes > 0) {
          _minutes--;
          _seconds = 59;
        } else if (_minutes == 0) {
          if (_hours > 0) {
            _hours--;
            _minutes = 59;
            _seconds = 59;
          }
        }
      } else {
        _seconds--;
      }
    } else {
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
  }

  void addLap(int hours, int minutes, int seconds) {
    if (_laps.length == 0) {
      _laps.add(new Lap(hours, minutes, seconds, hours, minutes, seconds));
    } else {
      _laps.add(new Lap(
          hours,
          minutes,
          seconds,
          (hours - _laps[_laps.length - 1].hours),
          (minutes - _laps[_laps.length - 1].minutes),
          (seconds - _laps[_laps.length - 1].seconds)));
    }
  }

  void resetLaps() {
    _laps.clear();
  }

  int get minutes {
    return _minutes;
  }

  int get seconds {
    return _seconds;
  }

  int get hours {
    return _hours;
  }

  bool get status {
    return _status;
  }

  Laps get laps {
    return _laps;
  }

  set seconds(int seconds) => this._seconds = seconds;
  set minutes(int minutes) => this._minutes = minutes;
  set hours(int hours) => this._hours = hours;
}
