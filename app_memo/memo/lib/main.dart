import 'package:memo/pages/authenticate/authenticate.dart';
import 'package:memo/pages/home/categories.dart';
import 'package:memo/pages/home/memos.dart';
import 'package:memo/pages/home/tags.dart';
import 'package:memo/utils/client.dart';
import 'package:flutter/material.dart';

//Variabili
final String VERSION = "v0.1";
final String SERVER_WEB = "https://lorenzovaccher.com:8443";
final String DATABASE_NAME = "app_database.db";

Client client;

Future main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp (
        debugShowCheckedModeBanner: false,
        title: 'App Memo',
        theme: ThemeData(
            primaryColor: Color(0xFF075E55),
            accentColor: Color(0xFF038577),
            brightness: Brightness.light),
        initialRoute: '/authenticate',
        routes: {
          '/authenticate': (context) => AuthenticatePage(),
          '/home': (context) => MemosPage(),
          '/categories': (context) => CategoriesPage(),
          '/tags': (context) => TagsPage(),
        },
      );
}
