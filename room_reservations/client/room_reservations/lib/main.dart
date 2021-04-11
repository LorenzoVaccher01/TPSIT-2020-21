import 'package:flutter/material.dart';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/views/login/loginView.dart';

final String VERSION = "v0.1";
final String SERVER_WEB = "https://lorenzovaccher.com:8443";
final String DATABASE_NAME = "app_database.db";

Client client;

main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Room Reservations',
      theme: ThemeData(
            primaryColor: Color(0xFF075E55),
            accentColor: Color(0xFF038577),
            brightness: Brightness.light),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        /*'/home': (context) => HomePage(),*/
      },
    );
  }
}