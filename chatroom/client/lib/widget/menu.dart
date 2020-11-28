import './alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '../main.dart' as Main;

class Menu extends StatefulWidget {
  static final int _AVATARS_COUNT = 30;
  
  Menu();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedAvatar = null;

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
              new Alert(
                  context: context,
                  title: "Cambia avatar",
                  closeButton: false,
                  textConfirmButton: "Fatto",
                  textCanelButton: "",
                  body: ListView( //TODO: mostrare tutti gli avatar con i checkbox e appena l'utente preme il bottone inviare evento al server e cambiare immagine al client
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/avatars/${1}.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Checkbox(
                                value:  _selectedAvatar == 1 ? true : false,
                                activeColor: /*Theme.of(context).primaryColor*/ Colors.transparent,
                                checkColor: Theme.of(context).primaryColor,
                                onChanged: (bool val) {
                                  print(val);
                                  setState(() {
                                    val ? _selectedAvatar = null : _selectedAvatar = 1;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset('assets/avatars/${2}.png',
                                  height: 65, width: 65),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset('assets/avatars/${3}.png',
                                  height: 65, width: 65),
                            ),
                          ])
                        ],
                      ),
                    ],
                  ),
                  onClick: () {
                    print(_selectedAvatar);
                    if (_selectedAvatar != null) {
                      Main.client.imageId = _selectedAvatar;
                      Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
                        socket.write(json.encode({
                          "event": "changeImage",
                          "data": {"imageId": _selectedAvatar}
                        }));
                        socket.write('' + json.encode({"event": "end", " position": "changeImage"}));
                        socket.close();
                      });
                    }
                  });
            },
          ),
          Divider(),
          InkWell(
            child: ListTile(
                //TODO: eliminare account con relativi messaggi e chats
                title: Text(
                  'Elimina account',
                  style: TextStyle(fontSize: 15),
                ),
                leading: Icon(Icons.warning),
                dense: true),
            onTap: () {
              new Alert(
                title: "Eliminazione account",
                body: Text("Sei sicuro di voler eliminare il tuo account?"),
                closeButton: true,
                textCanelButton: "No",
                textConfirmButton: "Si",
                context: context,
                onClick: () {
                  Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT)
                      .then((socket) {
                    var data = {
                      "event": "deleteAccount",
                      "client": Main.client.toJson()
                    };

                    /// send data
                    socket.write('' + json.encode(data));

                    ///listen data
                    socket.listen((event) {
                      var data = json.decode(utf8.decode(event));

                      if (data['event'] == 'deleteAccount') {
                        if (data['status'] == 200) {
                          socket.write('' + json.encode({"event": "end", " position": "deleteAccount"}));
                          socket.close();
                          Main.client = null;
                          Navigator.pushNamed(context, '/home');
                        } else {
                          socket.write('' + json.encode({"event": "end", " position": "deleteAccount"}));
                          socket.close();
                          //TODO: gestire errori
                        }
                      }
                    });
                  });
                },
              );
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
              Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
                socket.write('' + json.encode({"event": "end", " position": "*"}));
                socket.close();
              });
              Main.client = null;
              Navigator.pushNamed(context, '/home');
            },
          ),
          Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Versione: ${Main.VERSION}',
                style: TextStyle(fontSize: 14),
              )
            ],
          )
        ],
      ),
    );
  }
}
