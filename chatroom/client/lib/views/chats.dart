import '../utils/models/chats.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import './chat.dart';
import '../widget/menu.dart';
import '../main.dart' as Main;

class ChatsPage extends StatefulWidget {
  ChatsPage();

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<Chat> _chats = [];
  String _error = "";
  Socket _socket;

  @override
  void initState() {
    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
      var data = {"event": "chats", "client": Main.client.toJson()};
      _socket = socket;

      /// send data
      socket.write('' + json.encode(data));

      /// listen data
      socket.listen((event) {
        var data = json.decode(utf8.decode(event));

        //print(data);

        if (data['event'] == 'message') {
          if (data['status'] == 200) {
            for (var i = 0; i < _chats.length; i++) {
              if (_chats[i].id == data['data']['chatId']) {
                //TODO: riordinare le chats in base alla data dell'ultimo messaggio
                setState(() {
                  //TODO: aggiornare anche la data dell'ultimo messaggio
                  _chats[i].message.text = data['data']['message'];
                });
              }
            }
          }
        }

        if (data['event'] == 'chats') {
          if (data['status'] == 200) {
            for (var i = 0; i < data['data'].length; i++) {
              setState(() {
                _chats.add(new Chat.fromJson(data['data'][i]));
              });
            }
          } else {
            _socket.write(
                '' + json.encode({"event": "end", " position": "chats"}));
            _socket.close();
            setState(() {
              //TODO: gestire errori
              _error = data['error'];
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _socket.write('' + json.encode({"event": "end", " position": "chats"}));
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
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
                  text: 'Chats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 25.0,
          color: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: Menu(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.separated(
                reverse: false,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                itemCount: _chats.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(

                      ///Widget utilizzato come GestureDetector, con l'unica differenza che prende il 100% della lunghezza del contenitore e non solo la lunghezza dei Widget
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: _Chat(
                            _chats[index].id,
                            _chats[index].isGroup
                                ? _chats[index].message.sender.name
                                : _chats[index].users[0].name,
                            _chats[index].isGroup
                                ? null
                                : _chats[index].users[0].surname,
                            _chats[index].message.text,
                            _chats[index].isGroup
                                ? 31
                                : _chats[index].users[0].imageId,
                            _chats[index].isGroup,
                            _chats[index].groupName,
                            _chats[index].groupDescription),
                      ),
                      onTap: () {
                        _socket.write('' +
                            json.encode(
                                {"event": "end", " position": "chats"}));
                        _socket.close();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                      _chats[index].id,
                                      _chats[index].users, //TODO: inserire una lista per il gruppo
                                      _chats[index].isGroup
                                          ? 31
                                          : _chats[index].users[0].imageId,
                                      _chats[index].isGroup ? _chats[index].groupName : _chats[index].users[0].name,
                                      _chats[index].isGroup ? '' : _chats[index].users[0].surname,
                                    )));
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.pushNamed(context, '/contacts');
        },
      ),
    );
  }
}

class _Chat extends StatefulWidget {
  final int _id;
  final String _name;
  final String _surname;
  final String _message;
  final int _imageId;
  final bool _isGroup;
  final String _groupDescription;
  final String _groupName;

  _Chat(this._id, this._name, this._surname, this._message, this._imageId,
      this._isGroup, this._groupName, this._groupDescription);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<_Chat> {
  /// Metodo utilizzato per troncare il messaggio dopo tot
  /// caratteri per evitare overflow del testo.
  /// //TODO: fare il resize in base alla lunghezza del dispositivo
  String _cutMessage(String message) {
    if (message.length <= 30)
      return message;
    else
      return message.substring(0, 30) + '...';
  }

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
                child: Text(
                  widget._isGroup
                      ? "${widget._groupName}"
                      : "${widget._name} ${widget._surname}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ),
              Text(
                _cutMessage(widget._isGroup
                    ? widget._name + ': ' + widget._message
                    : widget._message),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
        ),
      ],
    );
  }
}
