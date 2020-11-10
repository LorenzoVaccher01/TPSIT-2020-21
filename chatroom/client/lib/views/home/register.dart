import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Container(
              //margin: EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/img/register.png", width: 80, height: 80),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text('Effettua la registrazione per iniziare!',
                        style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: _nameController,
                autocorrect: false,
                maxLength: 30,
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
                maxLength: 30,
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
                child: Text('Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                color: Colors.green,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
