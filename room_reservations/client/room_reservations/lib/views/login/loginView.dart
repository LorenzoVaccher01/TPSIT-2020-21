import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/utils/auth.dart';
import 'package:room_reservations/views/login/components/createAccountLabel.dart';
import 'package:room_reservations/views/login/components/googleButton.dart';
import 'package:room_reservations/views/login/components/title.dart';
import 'package:room_reservations/widget/blazierContainer.dart';
import 'package:room_reservations/widget/entryField.dart';
import 'package:room_reservations/widget/submitButton.dart';
import 'package:room_reservations/views/login/components/divider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    LoginTitle(),
                    SizedBox(height: 50),
                    EntryField(
                      title: "Email",
                      isPassword: false,
                      icon: Icon(Icons.person),
                      controller: _emailController,
                      hintText: "test@gmail.com",
                    ),
                    EntryField(
                      title: "Password",
                      isPassword: true,
                      icon: Icon(Icons.lock),
                      controller: _passwordController,
                      hintText: "*************",
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      child: SubmitButton("Login"),
                      onTap: () async {
                        User user;
                        try {
                        user = await Auth.signIn(_emailController.text, _passwordController.text);
                        } catch (error) {
                          print(error);
                        }
                        print(_emailController.text);
                        print(_passwordController.text);
                        print(user);
                      }
                    ),
                    SizedBox(height: 20),
                    LoginDivider(),
                    LoginGoogleButton(),
                    SizedBox(height: height * .025),
                    LoginCreateAccountLabel(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
