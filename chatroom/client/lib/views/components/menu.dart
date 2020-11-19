import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart' as Main;

class Menu extends StatelessWidget {
  Menu();

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
                Image.asset("assets/avatars/${Main.client.imageId}.png",
                    height: 70, width: 70),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(Main.client.name + ' ' + Main.client.surname,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  '@' + Main.client.nickname,
                  style: TextStyle(color: Colors.grey[200], fontSize: 16),
                )
              ],
            ),
          ),
          InkWell(
            child: ListTile(
                title: Text(
                  'Nuovo messaggio',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Icon(Icons.message),
                dense: true),
            onTap: () {
              Navigator.pushNamed(context, '/contacts');
            },
          ),
          InkWell(
            child: ListTile(
                title: Text(
                  'Cambia avatar',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Icon(Icons.person),
                dense: true),
            onTap: () {
              Navigator.pushNamed(context, '/contacts');
            },
          ),
          Divider(),
          InkWell( //TODO: chiedere conferma
            child: ListTile( //TODO: eliminare account con relativi messaggi e chats
                title: Text(
                  'Elimina account',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Icon(Icons.warning),
                dense: true),
            onTap: () {
              
            },
          ),
          InkWell(
            child: ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Icon(Icons.exit_to_app),
                dense: true),
            onTap: () {
              Main.client = null;
              Navigator.pushNamed(context, '/home');
            },
          ),
          Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ Text(
              'Versione: ${Main.VERSION}',
              style: TextStyle(fontSize: 14),
            )],
          )
        ],
      ),
    );
  }
}
