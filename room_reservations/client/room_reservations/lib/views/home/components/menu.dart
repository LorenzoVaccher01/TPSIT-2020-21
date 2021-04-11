import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:room_reservations/main.dart' as App;
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
                Image.asset("assets/img/compose.png", height: 60, width: 60),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                      App.client.name.substring(0, 1).toUpperCase() +
                          App.client.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
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
                    'Memos',
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.note_add),
                  dense: true),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              }),
          Divider(),
          InkWell(
              child: ListTile(
                  title: Text(
                    'Categories',
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.category),
                  dense: true),
              onTap: () {
                Navigator.pushNamed(context, '/categories');
              }),
          Divider(),
          InkWell(
              child: ListTile(
                  title: Text(
                    'Tags',
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.tag),
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
              final response = await http
                  .post(Uri.parse(App.SERVER_WEB + '/logout'), headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              });

              if (response.statusCode == 200) {
                final bodyResponse = json.decode(response.body);
                if (bodyResponse['error'] == 200) {
                  App.client = null;
                  Navigator.pushNamed(context, '/login');
                } else {
                  Alert(
                      context: context,
                      title: 'Error!',
                      closeButton: false,
                      textConfirmButton: 'Ok',
                      body: Text(bodyResponse['message']),
                      textCanelButton: "",
                      onClick: () {});
                  setState(() {});
                }
              } else {
                Alert(
                    context: context,
                    title: 'Error!',
                    closeButton: false,
                    textConfirmButton: 'Ok',
                    body: Text('Internal server Error.'),
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
