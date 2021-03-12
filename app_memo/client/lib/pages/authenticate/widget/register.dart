import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import '../../../utils/client.dart';
import '../../../main.dart' as App;

class RegisterView extends StatefulWidget {
  RegisterView();

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
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
                      child: Text('Sign up to get started!',
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
                  maxLength: 50,
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
                  maxLength: 50,
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
                  controller: _emailController,
                  autocorrect: false,
                  obscureText: false,
                  maxLength: 70,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: 'test@test.com',
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
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 25),
                child: RaisedButton(
                  child: Text('Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  color: Colors.green,
                  onPressed: () async {
                    final response =
                        await http.post(App.SERVER_WEB + '/register',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode({
                              'name': _nameController.text,
                              'surname': _surnameController.text,
                              'email': _emailController.text,
                              'password': _passwordController.text
                            }));

                    if (response.statusCode == 200) {
                      final bodyResponse = json.decode(response.body);
                      if (bodyResponse['error'] == 200) {
                        _error = "";
                        setState(() {});
                        App.client = new Client(
                            id: bodyResponse['userData']['id'],
                            name: bodyResponse['userData']['name'],
                            surname: bodyResponse['userData']['surname'],
                            email: bodyResponse['userData']['email'],
                            sessionCookie: response.headers['set-cookie']);
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        _prefs.setString('user.name', App.client.name);
                        _prefs.setString('user.surname', App.client.surname);
                        _prefs.setString('user.email', App.client.email);
                        _prefs.setInt('user.id', App.client.id);
                        _prefs.setString(
                            'user.sessionCookie', App.client.sessionCookie);
                        Navigator.pushNamed(context, '/home');
                      } else {
                        _error = bodyResponse['message'];
                        setState(() {});
                      }
                    } else {
                      _error = "Failed to load page!";
                      setState(() {});
                    }
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
