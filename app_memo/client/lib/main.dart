import 'package:app_memo/pages/authenticate/authenticate.dart';
import 'package:app_memo/pages/home/categories.dart';
import 'package:app_memo/pages/home/memo.dart';
import 'package:app_memo/pages/home/tags.dart';
import 'package:app_memo/utils/client.dart';
import 'package:flutter/material.dart';

final String VERSION = "v0.1";
final String SERVER_WEB = "https://lorenzovaccher.com:8443";

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
          '/home': (context) => MemoPage(),
          '/categories': (context) => CategoriesPage(),
          '/tags': (context) => TagsPage(),
        },
      );
}