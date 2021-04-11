import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/utils/connection.dart';
import 'package:room_reservations/views/home/homeView.dart';
import 'package:room_reservations/views/login/loginView.dart';
import 'package:room_reservations/views/signup/signupView.dart';

final String VERSION = "v0.1";
final String SERVER_WEB = "https://lorenzovaccher.com:8443";
final String DATABASE_NAME = "app_database.db";

Client client;
bool isConnected = false;

main() async {
  runApp(App());
}

class App extends StatelessWidget {
  ConnectionChecker _connectivity = ConnectionChecker.instance;
  
  @override
  Widget build(BuildContext context) {
    Map _source = {ConnectivityResult.none: false};

    _connectivity.initialise();
    _connectivity.stream.listen((source) {
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.none:
          isConnected = false;
          break;
        case ConnectivityResult.mobile:
          isConnected = true;
          break;
        case ConnectivityResult.wifi:
          isConnected = true;
      }

      //TODO: mostrare alert come avviso per la disconnessione e connessione a internet?
      if (isConnected)
        print("The client is connected to the internet");
      else 
        print("The client is not connected to the internet");
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Room Reservations',
      theme: ThemeData(
          primaryColor: Color(0xfff7892b),
          accentColor: Color(0xfffbb448),
          brightness: Brightness.light),
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
        '/home': (context) => HomeView()
      },
    );
  }
}
