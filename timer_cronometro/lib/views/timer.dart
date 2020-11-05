import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clock.dart';

class TimerView extends StatefulWidget {
  TimerView();

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  /// Inizializzazione della variabile _Clock con un secondo di durata (tempo
  /// utilizzato tra un tick e un altro) e con il campo reverse "false" in quanto il tempo
  /// parte da 0 e non da n a 0
  Clock _clock = new Clock(Duration(seconds: 1), true);

  /// Variabile privata utilizzata per gestire lo Stream.
  /// A questa variabile viene associato il ritorno di Stream.listen()
  StreamSubscription _streamSubscription;

  /// Funzione utilizzato per avviare il conteggio dei secondi, minuti e ore. Se lo stato del
  /// Clock è "true", allora quanto tale funzione viene invocata ferma il conteggio del tempo,
  /// altrimenti avvia il Cronometro
  void _startCounter() {
    if (_clock.status) {
      _clock.stop(_streamSubscription);
      setState(() {});
    } else {
      _streamSubscription = _clock.start().listen((data) => {
            _clock.addSecond(),
            if (_clock.hours == 0 && _clock.minutes == 0 && _clock.seconds == 0)
              {_clock.stop(_streamSubscription)},
            setState(() {})
          });
    }
  }

  /// Funzione utilizzata per resettare il clock. Quando tale funzione viene invocata,
  /// le ore, i secondi e i minuti vengono portati a 0 e inoltre vengono resettati anche i
  /// giri parziali
  void _resetClock() {
    _clock.reset();
    setState(() {});
  }

  /// Metodo invocato quando il Widget viene tolto dall'albero dei Widget
  @override
  void dispose() {
    if (_streamSubscription != null) _clock.pause(_streamSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Opacity(
                        child: RaisedButton(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: Colors.green[700],
                          ),
                          onPressed: _clock.status
                              ? null
                              : () => {
                                    if (_clock.hours < 99)
                                      {
                                        _clock.hours++,
                                        setState(() {}),
                                      }
                                  },
                        ),
                        opacity: _clock.status ? 0 : 1,
                      ),
                    ),
                    Text(
                      '${_clock.hours.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Opacity(
                          child: RaisedButton(
                            color: Colors.grey[100],
                            child: Icon(
                              Icons.remove,
                              size: 35,
                              color: Colors.red[700],
                            ),
                            onPressed: _clock.status
                                ? null
                                : () => {
                                      if (_clock.hours > 0)
                                        {
                                          _clock.hours--,
                                          setState(() {}),
                                        }
                                    },
                          ),
                          opacity: _clock.status ? 0 : 1,
                        ))
                  ],
                ),
                Text(
                  ':',
                  style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Opacity(
                        child: RaisedButton(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: Colors.green[700],
                          ),
                          onPressed: _clock.status
                              ? null
                              : () => {
                                    if (_clock.minutes < 59)
                                      {
                                        _clock.minutes++,
                                        setState(() {}),
                                      }
                                  },
                        ),
                        opacity: _clock.status ? 0 : 1,
                      ),
                    ),
                    Text(
                      '${_clock.minutes.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Opacity(
                        child: RaisedButton(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.remove,
                            size: 35,
                            color: Colors.red[700],
                          ),
                          onPressed: _clock.status
                              ? null
                              : () => {
                                    if (_clock.minutes > 0)
                                      {
                                        _clock.minutes--,
                                        setState(() {}),
                                      }
                                  },
                        ),
                        opacity: _clock.status ? 0 : 1,
                      ),
                    )
                  ],
                ),
                Text(
                  ':',
                  style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Opacity(
                        child: RaisedButton(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: Colors.green[700],
                          ),
                          onPressed: _clock.status
                              ? null
                              : () => {
                                    if (_clock.seconds < 59)
                                      {
                                        _clock.seconds++,
                                        setState(() {}),
                                      }
                                  },
                        ),
                        opacity: _clock.status ? 0 : 1,
                      ),
                    ),
                    Text(
                      '${_clock.seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Opacity(
                        child: RaisedButton(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.remove,
                            size: 35,
                            color: Colors.red[700],
                          ),
                          onPressed: _clock.status
                              ? null
                              : () => {
                                    if (_clock.seconds > 0)
                                      {
                                        _clock.seconds--,
                                        setState(() {}),
                                      }
                                  },
                        ),
                        opacity: _clock.status ? 0 : 1,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 70),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: _clock.status ? Colors.red : Colors.green,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                            _clock.status ? Icons.pause : Icons.play_arrow)),
                    onPressed: _startCounter,
                  ),
                  Visibility(
                    child: new RaisedButton(
                      color: Colors.grey[300],
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.repeat)),
                      onPressed: _resetClock,
                    ),
                    visible: ((_clock.seconds == 0 &&
                            _clock.minutes == 0 &&
                            _clock.hours == 0 &&
                            !(_clock.status))
                        ? false
                        : true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
