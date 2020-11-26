import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import '../../../utils/client.dart';
import '../../../main.dart' as Main;

class RegisterView extends StatefulWidget {
  RegisterView();

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
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
                    Image.asset("assets/img/register.png",
                        width: 80, height: 80),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('Effettua la registrazione per iniziare!',
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
                  controller: _nameController,
                  autocorrect: false,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: 'Mario',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: _surnameController,
                  autocorrect: false,
                  obscureText: false,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Surname',
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: 'Rosssi',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: _nicknameController,
                  autocorrect: false,
                  obscureText: false,
                  maxLength: 30,
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
                  maxLength: 25,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: '*************',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 25),
                child: RaisedButton(
                  child: Text('Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  color: Colors.green,
                  onPressed: () {
                    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT)
                        .then((socket) {
                      var data = {
                        "event": "registration",
                        "data": {
                          "name": _nameController.text,
                          "surname": _surnameController.text,
                          "nickname": _nicknameController.text,
                          "password": _passwordController.text,
                          "imageId": (new Random().nextInt(30) + 1)
                        }
                      };

                      /// send data
                      socket.write('' + json.encode(data));

                      /// listen data
                      socket.listen((event) {
                        var data = json.decode(utf8.decode(event));

                        if (data['event'] == 'registration') {
                          if (data['status'] == 200) {
                            Main.client = new Client(
                                id: data['user']['id'],
                                imageId: data['user']['imageId'],
                                name: data['user']['name'],
                                surname: data['user']['surname'],
                                nickname: data['user']['nickname'],
                                token: data['user']['token']);
                            socket.write('' +
                                json.encode({
                                  "event": "end",
                                  " position": "registration"
                                }));
                            socket.close();
                            Navigator.pushNamed(context, '/chats');
                          } else {
                            setState(() {
                              _error = data['error'];
                            });
                          }
                        }
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
