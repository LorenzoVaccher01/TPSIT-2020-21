import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:timer/utils/clock.dart';

class TimerView extends StatefulWidget {
  TimerView();

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  Clock _clock = new Clock(Duration(seconds: 1), true);
  // ignore: cancel_subscriptions
  StreamSubscription _streamSubscription;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row (
            children: [
              Column(
                children: [
                  
                ],
              )
            ],
          )
          Container(
            margin: EdgeInsets.only(top: 100),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
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
