import 'package:flutter/material.dart';

import 'views/timer.dart';
import 'views/stopwatch.dart';
import 'views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer & StopWatch', //titolo dell'app
      debugShowCheckedModeBanner: false, //toglie il banner di debug
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo, //Colore primario dell'applicazione
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 3, //Indica il numero di Tab presenti nel Menù
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight:
                70, //Altezza dell'AppBar (toglie lo spazio del Titolo)
            bottom: TabBar(
              tabs: [
                //Tab relativa alla Home
                Container(
                  //Tab per lo StopWatch
                  height: 67,
                  child: Tab(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Icon(Icons.home),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('Home'),
                        ),
                      ],
                    ),
                  ),
                ),
                //Tab relativa allo StopWatch
                Container(
                  //Tab per lo StopWatch
                  height: 67,
                  child: Tab(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Icon(Icons.watch),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('StopWatch'),
                        ),
                      ],
                    ),
                  ),
                ),
                //Tab relativa al Timer
                Container(
                  height: 67,
                  child: Tab(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Icon(Icons.timer),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('Timer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Widget associati alle 3 Tabs dichiarate sopra
          body: TabBarView(
            children: [
              HomeView(),
              StopWatchView(),
              TimerView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.nightlight_round, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
