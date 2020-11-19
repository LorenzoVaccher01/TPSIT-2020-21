import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import '../main.dart' as Main;

class ChatPage extends StatefulWidget {
  final int _peerId;
  final String _peerName;
  final String _peerSurname;
  List<String> _messages;
  bool _peerIsOnline = false;

  ChatPage(this._peerId, this._peerName, this._peerSurname);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  String _error = "";

  @override
  void initState() {
    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
      var data = {"event": "getChat", "peerId": 2, "client": Main.client.toJson()};

      /// send data
      socket.write('' + json.encode(data));

      /// listen data
      socket.listen((event) {
        var data = json.decode(utf8.decode(event));

        if (data['status'] == 200) {
          //TODO: ricevere tutti i messaggi
          //TODO: inserire tutti i messaggi
        } else {
          setState(() {
            //TODO: gestire errori
            _error = data['error'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [ //TODO: aggiungere immagina del profilo stile WhatsApp
              TextSpan(
                  text: '${widget._peerName} ${widget._peerSurname}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/chats');
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFE5DDD5),
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 10, bottom: 15),
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return _Message(
                      'Ciao! $index. Questo è un messaggio di test per testare il container di questo messaggio molto messaggioso!',
                      /*('Oggi 10:$index'),*/
                      (index % 2 == 0 ? true : false));
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.only(left: 15),
            height: 55,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Invia un messaggio...',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 25,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    print(_textController.text);
                    _textController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String _message;
  //final String _time;
  final bool _isPeer;

  _Message(this._message, /*this._time,*/ this._isPeer);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isPeer ? Color(0xFFFFFFFF) : Color(0xFFdcf8c6),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(
          top: 15, left: (_isPeer ? 20 : 80), right: (_isPeer ? 80 : 20)),
      padding: EdgeInsets.all(10),
      child:
          Text(_message, style: TextStyle(color: Colors.black, fontSize: 14)),
    );
  }
}
