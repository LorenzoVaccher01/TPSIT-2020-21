import 'dart:collection';

class Lap {
  int _seconds;
  int _minutes;
  int _hours;

  int _secondsPassed;
  int _minutesPassed;
  int _hoursPassed;

  Lap(this._hours, this._minutes, this._seconds, this._hoursPassed,
      this._minutesPassed, this._secondsPassed);

  int get minutes {
    return _minutes;
  }

  int get seconds {
    return _seconds;
  }

  int get hours {
    return _hours;
  }

  int get secondsPassed {
    return _secondsPassed;
  }

  int get minutesPassed {
    return _minutesPassed;
  }

  int get hoursPassed {
    return _hoursPassed;
  }
}

class Laps<Lap> extends ListBase<Lap> {
  List<Lap> _laps;

  Laps() : _laps = new List<Lap>();

  @override
  void add(Lap value) => _laps.add(value);

  @override
  void addAll(Iterable<Lap> iterable) => _laps.addAll(iterable);

  void operator []=(int index, Lap value) {
    _laps[index] = value;
  }

  Lap operator [](int index) => _laps[index];

  @override
  int get length => _laps.length;

  @override
  set length(int length) => _laps.length = length;
}
