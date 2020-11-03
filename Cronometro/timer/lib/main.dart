import 'package:flutter/material.dart';
import 'package:timer/views/timer.dart';
import 'utils/clock.dart';
import 'views/timer.dart';
import 'views/stopwatch.dart';
import 'views/home.dart';

Clock homeClock = new Clock(Duration(seconds: 1), false);
Clock stopWatchClock = null;
Clock timerClock = null;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer & StopWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 3, //Indica il numero di Tab presenti nel Menù
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70, //Altezza dell'AppBar (toglie lo spazio del Titolo)
            bottom: TabBar(
              tabs: [
                Container( //Tab per lo StopWatch
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
                Container( //Tab per lo StopWatch
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
              onTap: (index) {
                if (index == 0) {
                  stopWatchClock = null;
                  timerClock = null;
                  homeClock = new Clock(Duration(seconds: 1), false);
                }
                if (index == 1) {
                  homeClock = null;
                  stopWatchClock = new Clock(Duration(seconds: 1), false);
                  timerClock = null;
                }
                if (index == 2) {
                  homeClock = null;
                  stopWatchClock = null;
                  timerClock = new Clock(Duration(seconds: 1), true);
                }
              },
            ),
          ),
          body: TabBarView(
            children: [
              HomeView(),
              StopWatchView(),
              TimerView(),
            ],
          ),
        ),
      ),
    );
  }
}
