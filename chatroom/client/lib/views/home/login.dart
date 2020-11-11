import 'dart:io';

import 'package:client/utils/services/server.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/login.png", width: 80, height: 80),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('Effettua il Login per accedere al tuo account!',
                      style: TextStyle(fontSize: 16)),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: _nicknameController,
                autocorrect: false,
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(fontSize: 18),
                  hintText: 'mariorossi_01',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: _passwordController,
                autocorrect: false,
                obscureText: true,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 18),
                  hintText: '*************',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: RaisedButton(
                child: Text('Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                color: Colors.green,
                onPressed: () async {
                  _nicknameController.text;
                  ServerConnection serverConnection = new ServerConnection();
                  var result = serverConnection.login(nickname: _nicknameController.text, password: _passwordController.text);
                  print(result);
                  //Navigator.pushNamed(context, '/chat');
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

/// Classe utilizzata per gestire il comportamento di una ListView.
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}