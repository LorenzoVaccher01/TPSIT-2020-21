import './views/chats.dart';
import './views/contacts.dart';
import './views/home.dart';
import 'package:flutter/material.dart';
import './themeBuilder.dart';
import './utils/client.dart';

/// Indirizzo Ip del server. Tale costante viene utilizzata
/// per la connessione al server tramite WebSocket.
final String SOCKET_IP = "144.91.88.65";

/// Porta del server.
final int SOCKET_PORT = 25501;

/// Versione dell'applicazione
final String VERSION = "A0.7";

/// Variabile globale utilizzata per riferirsi al Client corrente.
/// Tutte le informazioni relative al client vengono ricevuto del server
/// tramite i socket.
Client client = null;

void main() {
  runApp(ThemeBuilder(
      defaultBrightness: Brightness.light,
      builder: (context, _brightness) {
        return MaterialApp(
          title: 'ChatRoom',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xFF075E55), 
              accentColor: Color(0xFF038577),
              //TODO: permettere all'utente di poter scegliare se avere il tema chiaro o scuro
              brightness: Brightness.light
            ),
          initialRoute: '/home',
          routes: {
            '/home': (context) => HomePage(),
            '/chats': (context) => ChatsPage(),
            '/contacts': (context) => Contacts()
          },
        );
      }));
}
