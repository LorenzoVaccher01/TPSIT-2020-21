import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/auth.dart';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/views/login/components/createAccountLabel.dart';
import 'package:room_reservations/views/login/components/googleButton.dart';
import 'package:room_reservations/views/login/components/title.dart';
import 'package:room_reservations/widget/alert.dart';
import 'package:room_reservations/widget/blazierContainer.dart';
import 'package:room_reservations/widget/entryField.dart';
import 'package:room_reservations/widget/submitButton.dart';
import 'package:room_reservations/views/login/components/divider.dart';

class LoginView extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                              user = await Auth.signIn(_emailController.text,
                                  _passwordController.text);
                              //print(await user.getIdToken(true));
                              if (user != null) {
                                App.client = new Client(
                                    email: user.email,
                                    name: user.displayName,
                                    uid: user.uid,
                                    imagePath: user.photoURL);
                                App.client.sessionCookie =
                                    await App.client.getSessionCookie();
                                Navigator.pushNamed(context, '/home');
                              }
                            } catch (error) {
                              Alert(
                                context: context,
                                closeButton: false,
                                title: "Error",
                                textConfirmButton: "Ok",
                                textCanelButton: "",
                                onClick: () {},
                                body: Text(error.toString().replaceAll(error.toString().substring(0, error.toString().indexOf("]") + 1), "").trim()),
                              );
                            }
                          }),
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
      ),
    );
  }
}
