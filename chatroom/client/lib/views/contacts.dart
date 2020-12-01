import 'package:ChatRoom/utils/models/chats.dart';
import 'package:ChatRoom/widget/alert.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/models/contacts.dart';
import '../views/chat.dart';
import 'dart:convert';
import '../main.dart' as Main;

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String _error = "";
  Socket _socket;
  List<Contact> _contacts = [];

  @override
  void initState() {
    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
      var data = {"event": "contacts", "client": Main.client.toJson()};
      _socket = socket;

      /// send data
      socket.write('' + json.encode(data));

      /// listen data
      socket.listen((event) {
        var data = json.decode(utf8.decode(event));

        if (data['event'] == 'contacts') {
          if (data['status'] == 200) {
            for (var i = 0; i < data['data'].length; i++) {
              print(data['data'][i]);
              _contacts.add(new Contact.fromJson(data['data'][i]));
              setState(() {});
            }
          } else {
            setState(() {
              _error = data['error'];
              socket.write(
                  '' + json.encode({"event": "end", " position": "contacts"}));
              socket.close();
              new Alert(
                  context: context,
                  title: "Errore",
                  body: Text(data['error']),
                  closeButton: true,
                  textCanelButton: "",
                  textConfirmButton: "Ok",
                  onClick: () {
                    _socket.close();
                    Navigator.pushNamed(context, '/chats');
                  });
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _socket.write('' + json.encode({"event": "end", " position": "contacts"}));
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Contacts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.separated(
                reverse: false,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      ///Widget utilizzato come GestureDetector, con l'unica differenza che prende il 100% della lunghezza del contenitore e non solo la lunghezza dei Widget
                      child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: _Contact(
                              _contacts[index].id,
                              _contacts[index].name,
                              _contacts[index].surname,
                              _contacts[index].nickname,
                              _contacts[index].imageId)),
                      onTap: () {
                        List<Users> user = [];
                        user.add(new Users(
                            id: _contacts[index].id,
                            imageId: _contacts[index].imageId,
                            name: _contacts[index].name,
                            surname: _contacts[index].surname));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    _contacts[index].chatId,
                                    false,
                                    user,
                                    _contacts[index].imageId,
                                    _contacts[index].name,
                                    _contacts[index].surname)));
                      });
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: Colors.grey,
                  height: 10,
                  thickness: 0.4,
                  indent: 70,
                  endIndent: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Contact extends StatefulWidget {
  final int _id;
  final String _name;
  final String _surname;
  final String _nickname;
  final int _imageId;

  _Contact(this._id, this._name, this._surname, this._nickname, this._imageId);

  @override
  __ContactState createState() => __ContactState();
}

class __ContactState extends State<_Contact> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 15),
          child: Image.asset("assets/avatars/${widget._imageId}.png",
              width: 55, height: 55),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget._name.substring(0, 1).toUpperCase()}${widget._name.substring(1)} ${widget._surname.substring(0, 1).toUpperCase()}${widget._surname.substring(1)}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                    Text(
                      "@${widget._nickname}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
