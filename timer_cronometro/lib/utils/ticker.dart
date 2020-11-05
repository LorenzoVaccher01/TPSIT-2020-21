
/// Classe che gestisce i Tick, ovvero segnali di tempo prestabiliti
/// in base a una durata, della classe Clock.
class Ticker {
  /// Intervallo tra un tick e un altro.
  Duration _duration;

  /// Stream che viene utilizzato per inviare un flusso di dati in modo costante.
  static Stream<int> _stream;

  Ticker(this._duration);

  /// Metodo utilizzato per istanziare lo Stream e per avviare il flusso di dati.
  Stream<int> start() {
    _stream = _timedCounter(_duration);
    return _stream;
  }

  /// Funzione utilizzata per la realizzazione di uno Stream dato un intervallo.
  /// L'intervallo viene gestito tramite il metodo delayed della classe Future.
  Stream<int> _timedCounter(Duration interval) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
    }
  }
}