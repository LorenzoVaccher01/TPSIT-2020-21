import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/auth.dart';
import 'package:room_reservations/utils/client.dart';
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
  final _nameController = TextEditingController();

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
                      height: 20,
                    ),
                    EntryField(
                      title: "Email",
                      isPassword: false,
                      icon: Icon(Icons.person),
                      controller: _emailController,
                      hintText: "test@gmail.com",
                    ),
                    EntryField(
                      title: "Name",
                      isPassword: false,
                      icon: Icon(Icons.person),
                      controller: _nameController,
                      hintText: "Mario Rossi",
                    ),
                    EntryField(
                      title: "Password",
                      isPassword: true,
                      icon: Icon(Icons.lock),
                      controller: _passwordController,
                      hintText: "*************",
                    ),
                    EntryField(
                      title: "Confirm password",
                      isPassword: true,
                      icon: Icon(Icons.lock),
                      controller: _confirmPasswordController,
                      hintText: "*************",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        child: SubmitButton("Signup"),
                        onTap: () async {
                          try {
                            if (_passwordController.text ==
                                _confirmPasswordController.text &&
                                (_nameController.text != null &&
                                _nameController.text != '' &&
                                _nameController.text != ' ')) {
                              User user = await Auth.signUp(
                                  _emailController.text,
                                  _passwordController.text);
                              
                              if (user != null) {
                                await user.updateProfile(displayName: _nameController.text, photoURL: App.DEFAULT_IMAGE_SERVER);
                                
                                App.client = new Client(
                                    email: user.email,
                                    name: _nameController.text,
                                    uid: user.uid,
                                    imagePath: App.DEFAULT_IMAGE_SERVER);
                                App.client.sessionCookie =
                                    await App.client.getSessionCookie();
                                Navigator.pushNamed(context, '/home');
                              }
                            } else {
                              throw ("Passwords do not match or user name is empty.");
                            }
                          } catch (error) {
                            Alert(
                                context: context,
                                title: 'Error!',
                                closeButton: false,
                                textConfirmButton: 'Ok',
                                body: Text(error
                                    .toString()
                                    .replaceAll(
                                        error.toString().substring(0,
                                            error.toString().indexOf("]") + 1),
                                        "")
                                    .trim()),
                                textCanelButton: "",
                                onClick: () {});
                          }
                        }),
                    SizedBox(height: height * .005),
                    SignupLoginAccountLabel(),
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
