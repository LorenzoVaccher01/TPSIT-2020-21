import 'package:client/views/chats.dart';
import 'package:client/views/home.dart';
import 'package:flutter/material.dart';

import './utils/client.dart';

/// Indirizzo Ip e porta del server. Tale costante viene utilizzata
/// per la connessione al server tramite WebSocket.
final String SOCKET_IP = "144.91.88.65";

/// Variabile globale utilizzata per riferirsi al Client corrente.
/// Tutte le informazioni relative al client vengono ricevuto del server
/// tramite i socket.
Client client = null;

void main() {
  runApp(MaterialApp(
    title: 'ChatRoom',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color(0xFF075E55),
      accentColor: Color(0xFF50aba1)
    ),
    initialRoute: '/home',
    routes: {
      '/home': (context) => HomePage(),
      '/chats': (context) => ChatsPage(),
    },
  ));
}

