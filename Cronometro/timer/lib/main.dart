import 'package:flutter/material.dart';
import 'views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro - Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      /*initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/timer': (context) => TimerScreen()
      }*/
      home: HomeScreen(title: 'Home page'),
    );
  }
}