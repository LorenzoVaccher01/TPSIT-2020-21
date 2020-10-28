 /**
 * Classe per generare un segnale che funge da metronomo per la classe Clock.
 */
class Ticker {
  Duration duration;
  static Stream<int> _stream;

  Ticker(this.duration);

  Stream<int> start() {
    _stream = timedCounter(duration);
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