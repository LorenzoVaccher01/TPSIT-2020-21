import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

import './utils/models/tideData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'am029_maree',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'am029_maree'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TideData> _data;
  StreamSubscription _userAccelerometerSub;

  @override
  void initState() {
    _userAccelerometerSub =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      // vertical gesture
      setState(() {
        if (event.z.abs() > 2) _getData();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _userAccelerometerSub.cancel();
    super.dispose();
  }

  void _getData() async {
    List<TideData> data = await fetchDataList();
    setState(() {
      _data = data;
    });
  }

  Color _getColor(double val) {
    if (val == null) return Colors.black;
    if (val < 0.80) {
      return Colors.green;
    } else if (val < 1.0) {
      return Colors.yellow;
    } else if (val < 1.2) {
      return Colors.orange;
    } else if (val < 1.8) {
      return Colors.red;
    } else {
      return Colors.purple;
    }
  }

  TideData _getPiattaforma() {
    for (TideData d in _data) {
      if (d.idStazione == "01021") return d;
    }
    return null;
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
          children: (_data == null)
              ? <Widget>[
                  Text(
                    'get data!',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ]
              : <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _data[0].data,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Stazione: ${_data[0].stazione}',
                  ),
                  Text(
                    _data[0].valore,
                    style: TextStyle(
                      fontSize: 40,
                      color: _getColor(_data[0].valoreDouble),
                    ),
                  ),
                  Text(
                    'in laguna se dato presente in \"01021\"',
                  ),
                  Text(
                    _getPiattaforma().valore ?? ' ',
                    style: TextStyle(
                      fontSize: 40,
                      color: _getColor(_getPiattaforma().valoreDouble),
                    ),
                  ),
                ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Get Data',
        child: Icon(Icons.arrow_downward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
