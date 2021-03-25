import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import './widget/login.dart';
import './widget/register.dart';
import '../../utils/client.dart';
import '../../main.dart' as App;

/// Pagina principale del progetto, tale pagina viene utilizzata
/// per il login o la registrazione di un nuovo utente
class AuthenticatePage extends StatelessWidget {

  Future<bool> _isLogged(BuildContext context) async {
    //TODO: commento shared_pref
    /*SharedPreferences _prefs = await SharedPreferences.getInstance();
    String cookie = _prefs.getString('user.sessionCookie');*/
    /*if (cookie != null) {
          const Map<String, int> monthsInYear = {
        "Jan": 1,
        "Feb": 2,
        "Mar": 3,
        "Apr": 4,
        "May": 5,
        "Jun": 6,
        "Jul": 7,
        "Aug": 8,
        "Sep": 9,
        "Oct": 10,
        "Nov": 11,
        "Dec": 12
      };
      var date = cookie
          .split(';')[cookie.split(';').length - 2]
          .split('=')[1]
          .split(',')[1]
          .split(' ');

      DateTime cookieDate = DateTime(
          int.parse(date[3]),
          monthsInYear[date[2]],
          int.parse(date[1]),
          int.parse(date[4].split(':')[0]),
          int.parse(date[4].split(':')[1]),
          int.parse(date[4].split(':')[2]));

      if (cookieDate.isAfter(DateTime.now())) {
        App.client = new Client(
            id: _prefs.getInt('user.id'),
            name: _prefs.getString('user.name'),
            surname: _prefs.getString('user.surname'),
            email: _prefs.getString('user.email'),
            sessionCookie: _prefs.getString('user.sessionCookie'));
        return true;
      } else {
        return false;
      }
    } else*/
      return false;
  }

  @override
  Widget build(BuildContext context) {
    _isLogged(context)
        .then((value) => {if (value) Navigator.pushNamed(context, '/home')});

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
