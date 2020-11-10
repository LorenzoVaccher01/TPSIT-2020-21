import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class LoginView extends StatefulWidget {
  LoginView();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  /*SocketIO socket =
      SocketIOManager().createSocketIO('http://144.91.88.65:25501', '/');*/

  @override
  void initState() {
    //socket.init();
    /*Socket.connect('144.91.88.65', 25501).then((socket) => {
      print('To mare omo')
    });*/
    //socket.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
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
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
          ),
        ],
      ),
    ));
  }
}
