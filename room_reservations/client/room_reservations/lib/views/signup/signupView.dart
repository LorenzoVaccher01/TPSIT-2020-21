import 'package:flutter/material.dart';
import 'package:room_reservations/utils/auth.dart';
import 'package:room_reservations/views/signup/components/loginAccountLabel.dart';
import 'package:room_reservations/views/signup/components/title.dart';
import 'package:room_reservations/widget/alert.dart';
import 'package:room_reservations/widget/blazierContainer.dart';
import 'package:room_reservations/widget/entryField.dart';
import 'package:room_reservations/widget/submitButton.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    SignupTitle(),
                    SizedBox(
                      height: 50,
                    ),
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
                      icon: Icon(Icons.person),
                      controller: _passwordController,
                      hintText: "*************",
                    ),
                    EntryField(
                      title: "Confirm password",
                      isPassword: true,
                      icon: Icon(Icons.person),
                      controller: _confirmPasswordController,
                      hintText: "*************",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SubmitButton("Signup"),
                    SizedBox(height: height * .065),
                    InkWell(
                      child: SignupLoginAccountLabel(),
                      onTap: () {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          Auth.signUp(
                              _emailController.text, _passwordController.text);
                          Navigator.pushNamed(context, '/login');
                        } else {
                          Alert(
                              context: context,
                              title: 'Error!',
                              closeButton: false,
                              textConfirmButton: 'Ok',
                              body: Text("Passwords do not match."),
                              textCanelButton: "",
                              onClick: () {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
