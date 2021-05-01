import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool emailNotification = true;
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                      "Settings",
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
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.email, size: 25, color: Colors.grey[500]),
                            Text("Notifications", style: TextStyle(color: Colors.grey[900], fontSize: 16)),
                            Switch(
                              value: notification,
                              onChanged: (value) {
                                setState(() {
                                  notification = value;
                                });
                              },
                              activeTrackColor: Theme.of(context).accentColor,
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.notification_important,
                                size: 25, color: Colors.grey[500]),
                            Text("Email notifications",
                                style: TextStyle(
                                    color: Colors.grey[900], fontSize: 16)),
                            Switch(
                              value: emailNotification,
                              onChanged: (value) {
                                setState(() {
                                  emailNotification = value;
                                });
                              },
                              activeTrackColor: Theme.of(context).accentColor,
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
                
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}
