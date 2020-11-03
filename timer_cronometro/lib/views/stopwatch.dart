import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clock.dart';

class StopWatchView extends StatefulWidget {
  StopWatchView();

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatchView> {
  Clock _clock = new Clock(Duration(seconds: 1), false);
  StreamSubscription _streamSubscription;

  _StopWatchState();

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

  void _resetClock() {
    _clock.reset();
    setState(() {});
  }

  void _addLap() {
    _clock.addLap(_clock.hours, _clock.minutes, _clock.seconds);
    setState(() {});
  }

  @override
  void dispose() {
    _clock.pause(_streamSubscription);
    _clock = null;
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
                                Text('Giro ' + (index + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Trascorsi ${_clock.laps[index].hoursPassed.toString().padLeft(2, '0')}:${_clock.laps[index].minutesPassed.toString().padLeft(2, '0')}:${_clock.laps[index].secondsPassed.toString().padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                '${_clock.laps[index].hours.toString().padLeft(2, '0')}:${_clock.laps[index].minutes.toString().padLeft(2, '0')}:${_clock.laps[index].seconds.toString().padLeft(2, '0')}',
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
                RaisedButton(
                  color: _clock.status ? Colors.red : Colors.green,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child:
                          Icon(_clock.status ? Icons.pause : Icons.play_arrow)),
                  onPressed: _startCounter,
                ),
                Visibility(
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
