import 'package:flutter/material.dart';

import './components/home/login.dart';
import './components/home/register.dart';

/// Pagina principale del progetto, tale pagina viene utilizzata
/// per il login o la registrazione di un nuovo utente
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E55),
          toolbarHeight: 70,
          elevation: 8.0,
          bottom: TabBar(
            tabs: [
              //Tab relativa al login
              _HomeTab('Login', Icons.person),
              //Tab relativa alla registrazione
              _HomeTab('Register', Icons.person_add),
            ],
          ),
        ),
        body: TabBarView(
          children: [LoginView(), RegisterView()],
        ),
      ),
    );
  }
}

/// Widget per la realizzazione delle Tab nella pagina principale,
/// ovvero Login e Register
class _HomeTab extends StatelessWidget {
  String _text;
  IconData _icon;

  _HomeTab(this._text, this._icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      child: Tab(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Icon(_icon, size: 30),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(_text, style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
