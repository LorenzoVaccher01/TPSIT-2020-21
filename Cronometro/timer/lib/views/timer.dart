import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/utils/clock.dart';

class TimerView extends StatefulWidget {
  TimerView();

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  Clock _clock = new Clock(Duration(seconds: 1), true);
  // ignore: cancel_subscriptions
  StreamSubscription _streamSubscription;

  void _startCounter() {
    _clock = new Clock(Duration(seconds: 1), true);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: RaisedButton(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.add,
                        size: 35,
                        color: Colors.green[700],
                      ),
                      onPressed: () => {
                        if (_hours < 99)
                          {
                            _hours++,
                            setState(() {}),
                          }
                      },
                    ),
                  ),
                  Text(
                    '${_hours.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.remove,
                        size: 35,
                        color: Colors.red[700],
                      ),
                      onPressed: () => {
                        if (_hours > 0)
                          {
                            _hours--,
                            setState(() {}),
                          }
                      },
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
                    child: RaisedButton(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.add,
                        size: 35,
                        color: Colors.green[700],
                      ),
                      onPressed: () => {
                        if (_minutes < 59)
                          {
                            _minutes++,
                            setState(() {}),
                          }
                      },
                    ),
                  ),
                  Text(
                    '${_minutes.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.remove,
                        size: 35,
                        color: Colors.red[700],
                      ),
                      onPressed: () => {
                        if (_minutes > 0)
                          {
                            _minutes--,
                            setState(() {}),
                          }
                      },
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
                    child: RaisedButton(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.add,
                        size: 35,
                        color: Colors.green[700],
                      ),
                      onPressed: () => {
                        if (_seconds < 59)
                          {
                            _seconds++,
                            setState(() {}),
                          }
                      },
                    ),
                  ),
                  Text(
                    '${_seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.remove,
                        size: 35,
                        color: Colors.red[700],
                      ),
                      onPressed: () => {
                        if (_seconds > 0)
                          {
                            _seconds--,
                            setState(() {}),
                          }
                      },
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
