import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clock.dart';

class TimerView extends StatefulWidget {
  TimerView();

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  Clock _clock = new Clock(Duration(seconds: 1), true);
  StreamSubscription _streamSubscription;

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

  void _resetClock() {
    _clock.reset();
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
