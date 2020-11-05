import 'dart:async';

import 'ticker.dart';
import 'laps.dart';

/// Classe che gestisce l'orario inteso come ore, minuti e secondi.
/// Tale classe estende la classe Ticker, utilizzata per la generazione di segnali
/// costanti impiegati per la sincronizzazione dell'ora
class Clock extends Ticker {
  int _minutes = 0;
  int _seconds = 0;
  int _hours = 0;

  /// Campo utilizzato per salvare lo stato dell'Orologio
  /// Se questo campo è "true" allora significa che è in stato di running,
  /// altrimenti l'Orologio è fermo
  bool _status = false;

  /// Intervallo tra un tick e un altro
  final Duration _duration;

  /// Campo utilizzato per invertire o meno il conteggio del tempo
  final bool _reverse;

  /// Lista utilizzata per salvare eventuali giri parziali
  Laps _laps = new Laps<Lap>();

  Clock(this._duration, this._reverse) : super(_duration);

  /// Metodo utilizzato per avviare il Clock. Il tipo di
  /// ritorno è uno Stream<int> fornendo un metodo asincrono
  /// per inviare dati in modo continuo e costante
  Stream<int> start() {
    _status = true;
    return super.start();
  }

  /// Metodo che, dato uno StreamSubscription ovvero il valore
  /// ritornato dal metodo listen() di uno Stream, mette in pausa il
  /// conteggio del tempo
  void pause(StreamSubscription streamSubscription) {
    _status = false;
    streamSubscription.pause();
  }

  /// Metodo che, dato uno StreamSubscription ovvero il valore
  /// ritornato dal metodo listen() di uno Stream, stoppa il
  /// conteggio del tempo
  void stop(StreamSubscription streamSubscription) {
    _status = false;
    streamSubscription.cancel();
  }

  /// Reset del tempo (porta a 0 i secondi, i minuti e le ore).
  /// Oltre a resettare il conteggio del tempo, questo metodo
  /// resetta, dove necessario, la lista Laps
  void reset() {
    _hours = 0;
    _seconds = 0;
    _minutes = 0;
    resetLaps();
  }

  /// In base a reverse questo metodo sottrae un secondo
  /// all'orario scelto (Timer) o ne aggiunge uno (StopWatch),
  /// tenendo in considerazione anche una eventuale somma o
  /// sottrazione di minuti/ore
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

  /// Aggiunge un giro alla lista Laps<Lap>
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

  /// Metodo utilizzato per resettare tutti i Lap presenti
  /// nella lista Laps<lap>
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
