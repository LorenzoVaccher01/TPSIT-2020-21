import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _colors = [
    Colors.black,
    Colors.amber,
    Colors.blue,
    Colors.cyan,
    Colors.brown
  ];
  int _score = 0;
  bool _visibilityStatus = true;

  int randomInclusive(int min, int max) {
    Random random = new Random();
    return random.nextInt(max) + min + 1;
  }

  void _startGame() {
    setState(() {
      _visibilityStatus = false;
    });
  }

  void _checkResult() {
    setState(() {
      _score++;
    });
  }

  void _resetGame() {
    setState(() {
      _score = 0;
      _visibilityStatus = true;
    });
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
              Visibility(
                child: Container(
                  alignment: Alignment(0.95, -1),
                  child: RaisedButton(
                    color: Colors.red,
                    child: Icon(Icons.fullscreen_exit),
                    onPressed: _resetGame,
                  ),
                ),
                visible: !_visibilityStatus,
              ),
              Visibility(
                child: Container(
                  child: Text('Clicca il tasto Start per iniziare a giocare!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.blueGrey)),
                ),
                visible: _visibilityStatus,
              ),
              Visibility(
                child: Text(
                  'Punti: $_score',
                  style: TextStyle(fontSize: 40, color: Colors.blueGrey),
                ),
                visible: !_visibilityStatus,
              ),
              Visibility(
                child: Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(top: 150),
                  color: Colors.black,
                ),
                visible: !_visibilityStatus,
              ),
              Visibility(
                child: Container(
                  margin: EdgeInsets.only(top: 150),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ButtonTheme(
                        height: 60,
                        minWidth: 60,
                        child: RaisedButton(
                          color: _colors[0],
                          onPressed: _checkResult,
                        ),
                      ),
                      ButtonTheme(
                        height: 60,
                        minWidth: 60,
                        child: RaisedButton(
                          color: _colors[1],
                          onPressed: _checkResult,
                        ),
                      ),
                      ButtonTheme(
                        height: 60,
                        minWidth: 60,
                        child: RaisedButton(
                          color: _colors[2],
                          onPressed: _checkResult,
                        ),
                      ),
                      ButtonTheme(
                        height: 60,
                        minWidth: 60,
                        child: RaisedButton(
                          color: _colors[3],
                          onPressed: _checkResult,
                        ),
                      ),
                      ButtonTheme(
                        height: 60,
                        minWidth: 60,
                        child: RaisedButton(
                          color: _colors[4],
                          onPressed: _checkResult,
                        ),
                      ),
                    ],
                  ),
                ),
                visible: !_visibilityStatus,
              ),
              Visibility(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: RaisedButton(
                    color: Colors.green,
                    padding: EdgeInsets.all(15),
                    child: Text('Start',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: _startGame,
                  ),
                ),
                visible: _visibilityStatus,
              ),
            ],
          ),
        ));
  }
}
