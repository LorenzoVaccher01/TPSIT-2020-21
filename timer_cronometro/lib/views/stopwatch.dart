import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clock.dart';

/// Widget della pagina StopWatch
class StopWatchView extends StatefulWidget {
  StopWatchView();

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatchView> {
  /// Inizializzazione della variabile _Clock con un secondo di durata (tempo
  /// utilizzato tra un tick e un altro) e con il campo reverse "false" in quanto il tempo
  /// parte da 0 e non da n a 0
  Clock _clock = new Clock(Duration(seconds: 1), false);

  /// Variabile privata utilizzata per gestire lo Stream.
  /// A questa variabile viene associato il ritorno di Stream.listen()
  StreamSubscription _streamSubscription;

  _StopWatchState();

  /// Funzione utilizzato per avviare il conteggio dei secondi, minuti e ore. Se lo stato del
  /// Clock è "true", allora quanto tale funzione viene invocata ferma il conteggio del tempo,
  /// altrimenti avvia il Cronometro
  void _startCounter() {
    if (_clock.status) {
      _clock.stop(_streamSubscription);
      setState(() {});
    } else {
      _streamSubscription = _clock
          .start()
          .listen((data) => {_clock.addSecond(), setState(() {})});
    }
  }

  /// Funzione utilizzata per resettare il clock. Quando tale funzione viene invocata,
  /// le ore, i secondi e i minuti vengono portati a 0 e inoltre vengono resettati anche i
  /// giri parziali
  void _resetClock() {
    _clock.reset();
    setState(() {});
  }

  /// Funzione che aggiunge un giro parziale
  void _addLap() {
    _clock.addLap(_clock.hours, _clock.minutes, _clock.seconds);
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
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Text(
                '${_clock.hours.toString().padLeft(2, '0')}:${_clock.minutes.toString().padLeft(2, '0')}:${_clock.seconds.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 40, color: Colors.blueGrey)),
          ),
          Visibility(
            child: Container(
              height: 350,
              margin: EdgeInsets.only(top: 10),
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: _clock.laps.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 70,
                      color: Colors.grey[200],
                      child: Container(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Giro ' + ((_clock.laps.length - index - 1) + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Trascorsi ${_clock.laps[(_clock.laps.length - index - 1)].hoursPassed.toString().padLeft(2, '0')}:${_clock.laps[(_clock.laps.length - index - 1)].minutesPassed.toString().padLeft(2, '0')}:${_clock.laps[(_clock.laps.length - index - 1)].secondsPassed.toString().padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                '${_clock.laps[(_clock.laps.length - index - 1)].hours.toString().padLeft(2, '0')}:${_clock.laps[(_clock.laps.length - index - 1)].minutes.toString().padLeft(2, '0')}:${_clock.laps[(_clock.laps.length - index - 1)].seconds.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 26)),
                          ],
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            visible: true,
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  // Bottone per aggiungere un lap
                  child: RaisedButton(
                    color: Colors.orange[300],
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.flag),
                    ),
                    onPressed: _addLap,
                  ),
                  visible: ((_clock.seconds == 0 &&
                          _clock.minutes == 0 &&
                          _clock.hours == 0 &&
                          !_clock.status)
                      ? false
                      : true),
                ),
                // Bottone start/stop
                RaisedButton(
                  color: _clock.status ? Colors.red : Colors.green,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child:
                          Icon(_clock.status ? Icons.pause : Icons.play_arrow)),
                  onPressed: _startCounter,
                ),
                Visibility(
                  // Bottone per il reset
                  child: new RaisedButton(
                    color: Colors.grey[300],
                    child: Container(
                        padding: EdgeInsets.all(5), child: Icon(Icons.repeat)),
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
    ));
  }
}
