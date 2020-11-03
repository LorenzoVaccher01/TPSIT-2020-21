import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clock.dart';

class HomeView extends StatefulWidget {
  HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription _streamSubscription;
  Clock _clock = new Clock(Duration(seconds: 1), false);
  final DateTime _dateTime = DateTime.now();
  final List<String> _weekDays = [
    "Lunedì",
    "Martedì",
    "Mercoledì",
    "Giovedì",
    "Venerdì",
    "Sabato",
    "Domenica"
  ];
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

  @override
  void initState() {
    _clock.hours = _dateTime.hour + 1;
    _clock.minutes = _dateTime.minute;
    _clock.seconds = _dateTime.second;
    _startCounter();
  }

  @override
  void dispose() {
    _clock.pause(_streamSubscription);
    _clock = null;
    super.dispose();
  }

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
