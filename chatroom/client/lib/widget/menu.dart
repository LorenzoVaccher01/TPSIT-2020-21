import 'package:ChatRoom/themeBuilder.dart';

import './alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '../main.dart' as Main;

int _selectedAvatar = Main.client.imageId;

class Menu extends StatefulWidget {
  static final int _AVATARS_COUNT = 30;

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
                Image.asset("assets/avatars/${Main.client.imageId}.png",
                    height: 70, width: 70),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                      Main.client.name.substring(0, 1).toUpperCase() +
                          Main.client.name.substring(1) +
                          ' ' +
                          Main.client.surname.substring(0, 1).toUpperCase() +
                          Main.client.surname.substring(1),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  '@' + Main.client.nickname,
                  style: TextStyle(color: Colors.grey[100], fontSize: 15),
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
                  body: _Avatars(),
                  onClick: () {
                    if (_selectedAvatar != null) {
                      Main.client.imageId = _selectedAvatar;
                      Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT)
                          .then((socket) {
                        socket.write(json.encode({
                          "event": "updateAvatar",
                          "client": Main.client.toJson(),
                          "data": {"imageId": _selectedAvatar}
                        }));

                        socket.listen((event) {
                          var data = json.decode(utf8.decode(event));
                          if (data['event'] == 'updateAvatar') {
                            if (data['status'] == 200) {
                              Main.client.imageId = _selectedAvatar;
                              setState(() {
                                
                              });
                            }
                          }

                          socket.write('' +
                              json.encode({
                                "event": "end",
                                "position": "updateAvatar"
                              }));
                          socket.close();
                        });
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
                          socket.write('' +
                              json.encode({
                                "event": "end",
                                " position": "deleteAccount"
                              }));
                          socket.close();
                          Main.client = null;
                          Navigator.pushNamed(context, '/home');
                        } else {
                          socket.write('' +
                              json.encode({
                                "event": "end",
                                " position": "deleteAccount"
                              }));
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
                socket.write(
                    '' + json.encode({"event": "end", " position": "*"}));
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

class _Avatars extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<_Avatars> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${1}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 1
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 1;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${2}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 2
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 2;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${3}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 3
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 3;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${4}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 4
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 4;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${5}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 5
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 5;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${6}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 6
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 6;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${7}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 7
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 7;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${8}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 8
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 8;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${9}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 9
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 9;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${10}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 10
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 10;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${11}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 11
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 11;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${12}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 12
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 12;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${13}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 13
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 13;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${14}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 14
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 14;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${15}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 15
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 15;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${16}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 16
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 16;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${17}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 17
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 17;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${18}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 18
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 18;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${19}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 19
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 19;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${20}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 20
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 20;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${21}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 21
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 21;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${22}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 22
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 22;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${23}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 23
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 23;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${24}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 24
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 24;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${25}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 25
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 25;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${26}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 26
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 26;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${27}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 27
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 27;
                  });
                },
              ),
            ]),
            TableRow(children: [
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${28}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 28
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 28;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${29}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 29
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 29;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/avatars/${30}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: _selectedAvatar == 30
                      ? Icon(Icons.check,
                          color: Theme.of(context).primaryColor, size: 50)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedAvatar = 30;
                  });
                },
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
