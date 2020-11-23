import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clock.dart';

/// Widget della pagina Home
class HomeView extends StatefulWidget {
  HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Variabile privata utilizzata per gestire lo Stream.
  /// A questa variabile viene associato il ritorno di Stream.listen()
  StreamSubscription _streamSubscription;
  
  /// Inizializzazione della variabile _Clock con un secondo di durata (tempo
  /// utilizzato tra un tick e un altro) e con il campo reverse "false" in quanto il tempo
  /// parte da 0 e non da n a 0
  Clock _clock = new Clock(Duration(seconds: 1), false);

  // Variabile utilizzata per ottenere la data e l'ora odierna
  final DateTime _dateTime = DateTime.now();

  /// Lista di stringhe contentenente tutti i giorni della settimana
  /// per convertire il dato numero (da 1 a 6) fornito dalla classe DateTime in Stringa
  final List<String> _weekDays = [
    "Lunedì",
    "Martedì",
    "Mercoledì",
    "Giovedì",
    "Venerdì",
    "Sabato",
    "Domenica"
  ];

  /// Lista di stringhe contenente tutti i mesi dell'anno, utilizzati per 
  /// convertire il dato numerico (da 0 a 11) fornito dalla classe DateTime in Stringa
  final List<String> _months = [
    "gennaio",
    "febbraio",
    "marzo",
    "aprile",
    "maggio",
    "giugno",
    "luglio",
    "agosto",
    "settembre",
    "ottobre",
    "novembre",
    "dicembre"
  ];

  _HomeViewState();

  /// Metodo utilizzato per inizializzare lo stato del Widget
  @override
  void initState() {
    _clock.hours = _dateTime.hour;
    _clock.minutes = _dateTime.minute;
    _clock.seconds = _dateTime.second;
    _startCounter();
    super.initState();
  }

  /// Metodo invocato quando il Widget viene tolto dall'albero dei Widget
  @override
  void dispose() {
    if (_streamSubscription != null) _clock.pause(_streamSubscription);
    super.dispose();
  }

  /// Funzione utilizzato per avviare il conteggio dei secondi, minuti e ore
  void _startCounter() {
    _streamSubscription =
        _clock.start().listen((data) => {_clock.addSecond(), setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Text(
                '${_clock.hours.toString().padLeft(2, '0')}:${_clock.minutes.toString().padLeft(2, '0')}:${_clock.seconds.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 40, color: Colors.blueGrey)),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text('Ora standard dell\'Europa centrale',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
                '${_weekDays[_dateTime.weekday - 1]} ${_dateTime.day} ${_months[_dateTime.month - 1]}',
                style: TextStyle(fontSize: 17, color: Colors.grey)),
          ),
        ],
      ),
    ));
  }
}
