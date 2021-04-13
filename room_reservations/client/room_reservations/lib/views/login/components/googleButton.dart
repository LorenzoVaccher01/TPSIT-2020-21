import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/utils/auth.dart';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/widget/alert.dart';

class LoginGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          User user = await Auth.signInWithGoogle();
          if (user != null) {
            App.client = new Client(
                email: user.email,
                name: user.displayName,
                uid: user.uid,
                loggedWithGoogle: true,
                imagePath: user.photoURL,
                getSession: true);
            Navigator.pushNamed(context, '/home');
          } else {
            throw("Something went wrong with accessing the application via the Google service.");
          }
        } catch (error) {
          Alert(
            context: context,
            closeButton: false,
            title: "Error",
            textConfirmButton: "Ok",
            textCanelButton: "",
            onClick: () {},
            body: Text(error
                .toString()
                .replaceAll(
                    error
                        .toString()
                        .substring(0, error.toString().indexOf("]") + 1),
                    "")
                .trim()),
          );
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black45)),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Image.asset("assets/icons/google_logo.png"),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Sign in with Google',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
