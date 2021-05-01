import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:room_reservations/main.dart' as App;

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Information",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("Email"),
                        subtitle: Text(App.client.email),
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text("Account provider"),
                        subtitle: Text(user.providerData[0].providerId),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("Phone"),
                        subtitle: Text(user.phoneNumber == null || user.phoneNumber == '' ? 'Unavailable' : user.phoneNumber),
                      ),
                      ListTile(
                        leading: Icon(Icons.emoji_people),
                        title: Text("Creation date"),
                        subtitle: Text(user.metadata.creationTime
                            .toLocal()
                            .toString()
                            .split(".")[0]),
                      ),
                      ListTile(
                        leading: Icon(Icons.login),
                        title: Text("Last login date"),
                        subtitle: Text(user.metadata.lastSignInTime
                            .toLocal().toString().split(".")[0]),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
