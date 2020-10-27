import 'package:flutter/material.dart';
import 'package:timer/views/timer.dart';
import 'views/timer.dart';
import 'views/stopwatch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Timer'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.watch),
                ),
                Tab(
                  icon: Icon(Icons.timer),
                ),
              ],
              onTap: (index) {
                //print(index);
              },
            ),
          ),
          body: TabBarView(
            children: [StopWatchView(), TimerView()],
          ),
        ),
      ),
    );
  }
}
