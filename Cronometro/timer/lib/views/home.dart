import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/utils/clock.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Clock _clock = new Clock(Duration(seconds: 1));
  StreamSubscription _streamSubscription;
  bool _clockStatus;

  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;

  void _startCounter() {
    if (_clock.status) {
      _clock.stop(_streamSubscription);
      setState(() {
        _clockStatus = _clock.status;
      });
    } else {
      setState(() {
        _clockStatus = _clock.status;
      });
      _streamSubscription = _clock.start().listen((data) => {
            _clock.addSecond(),
            setState(() {
              _seconds = _clock.seconds;
              _minutes = _clock.minutes;
              _hours = _clock.hours;
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Text(
                'Clicca il bottone sottostante \nper avviare/stoppare il timer.',
                style: TextStyle(fontSize: 22, color: Color(0xFF4e5257)),
              ),*/
              new Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                    '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 40, color: Colors.blueGrey)),
              ),
              new Container(
                  margin: EdgeInsets.only(top: 20),
                  child: new RaisedButton(
                    color: _clock.status ? Colors.red : Colors.green,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(_clock.status ? Icons.stop : Icons.play_arrow)),/*Text(_clock.status ? "Stop" : "Start",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),*/
                    onPressed: _startCounter,
                  ))
            ],
          ),
        ));
  }
}
