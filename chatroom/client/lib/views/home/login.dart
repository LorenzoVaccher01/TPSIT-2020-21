import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:client/utils/services/server.dart';
import '../../utils/client.dart';
import '../../main.dart' as Main;

class LoginView extends StatefulWidget {
  LoginView();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
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
            ),
            Visibility(
              visible: (_error != '' ? true : false),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20),
                child: Text(_error, style: TextStyle(color: Colors.red)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: _nicknameController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(fontSize: 18),
                  hintText: 'mariorossi_01',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: _passwordController,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 18),
                  hintText: '*************',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 45, bottom: 25),
              child: RaisedButton(
                child: Text('Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                color: Colors.green,
                onPressed: () async {
                  Socket.connect("144.91.88.65", 25501).then((socket) {
                    socket.write('{"event": "chats"}');
                    socket.listen((event) {
                      print('asd');
                      print(event);
                    });
                  });
                  /*ServerConnection serverConnection = new ServerConnection();
                  StreamSubscription channel;
                  channel = serverConnection
                      .login(
                          nickname: _nicknameController.text,
                          password: _passwordController.text)
                      .listen((event) {
                    var data = json.decode(event);
                    if (data['status'] == 200) {
                      Main.client = new Client(
                          id: data['user']['id'],
                          name: data['user']['name'],
                          surname: data['user']['surname'],
                          nickname: data['user']['nickname'],
                          token: data['user']['token']);
                      Navigator.pushNamed(context, '/chats');
                    } else {
                      setState(() {
                        _error = data['error'];
                      });
                    }
                    channel.cancel();
                  });*/
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
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
