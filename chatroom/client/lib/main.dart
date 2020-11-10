import 'package:client/views/home.dart';
import 'package:flutter/material.dart';
import './utils/client.dart';

final String SOCKET_URL = "https://144.91.88.65:25500";

/// Variabile globale utilizzata per riferirsi al Client corrente.
/// Tutte le informazioni relative al client vengono ricevuto del server
/// tramite i socket.
Client client;

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green, //0xFF2E7D32
      accentColor: Color(0xFFFEF9EB),
    ),
    initialRoute: '/home',
    routes: {
      '/home': (context) => HomePage(),
      '/chat': (context) => SecondScreen(),
    },
  ));
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

/*class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}*/
