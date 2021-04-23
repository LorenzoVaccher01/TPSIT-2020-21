import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/auth.dart';
import 'package:room_reservations/widget/alert.dart';

class Menu extends StatefulWidget {
  Menu();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor
                ]),
                color: Theme.of(context).primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(right: 15, top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    /*border:
                    Border.all(width: 2, color: Theme.of(context).primaryColor),*/
                    image: DecorationImage(
                        image: NetworkImage(
                            App.client.imagePath != null ? App.client.imagePath : App.DEFAULT_PROFILE_IMAGE),
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(App.client.name != null ? App.client.name : "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  App.client.email,
                  style: TextStyle(color: Colors.grey[100], fontSize: 13),
                )
              ],
            ),
          ),
          InkWell(
              child: ListTile(
                  title: Text(
                    'Events',
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.event),
                  dense: true),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              }),
          Divider(),
          InkWell(
              child: ListTile(
                  title: Text(
                    'New event',
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.event_available_outlined),
                  dense: true),
              onTap: () {
                Navigator.pushNamed(context, '/categories');
              }),
          Divider(),
          InkWell(
              child: ListTile(
                  title: Text(
                    'Settings',
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.miscellaneous_services),
                  dense: true),
              onTap: () {
                Navigator.pushNamed(context, '/tags');
              }),
          Divider(),
          InkWell(
            child: ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Icon(Icons.exit_to_app),
                dense: true),
            onTap: () async {
              try {
                final response = await http.post(
                    Uri.parse(App.SERVER_WEB + '/logout'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    });

                if (response.statusCode == 200) {
                  final bodyResponse = json.decode(response.body);
                  if (bodyResponse['error'] == 200) {
                    Auth.googleSignout();
                    App.client = null;
                    Navigator.pushNamed(context, '/login');
                  } else {
                    throw (bodyResponse['message']);
                  }
                } else {
                  throw("Internal server error");
                }
              } catch (e) {
                Alert(
                    context: context,
                    title: 'Error!',
                    closeButton: false,
                    textConfirmButton: 'Ok',
                    body: Text(e.toString()),
                    textCanelButton: "",
                    onClick: () {});
              }
            },
          ),
          Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Version: ${App.VERSION}',
                style: TextStyle(fontSize: 14),
              )
            ],
          )
        ],
      ),
    );
  }
}
