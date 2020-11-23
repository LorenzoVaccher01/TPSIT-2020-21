import 'package:client/utils/models/chats.dart';
import 'package:client/widget/alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import '../main.dart' as Main;

class ChatPage extends StatefulWidget {
  final int _peerId;
  final int _chatId;
  final String _peerName;
  final String _peerSurname;

  ChatPage(this._chatId, this._peerId, this._peerName, this._peerSurname);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  List<Message> _messages = [];
  String _error = "";

  @override
  void initState() {
    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
      var data = {
        "event": "chat",
        "peerId": widget._peerId,
        "chatId": widget._chatId,
        "client": Main.client.toJson()
      };

      /// send data
      socket.write('' + json.encode(data));

      /// listen data
      socket.listen((event) {
        var data = json.decode(utf8.decode(event));

        if (data['event'] == 'chat') {
          if (data['status'] == 200) {
            for (var i = 0; i < data['data'].length; i++) {
              _messages.add(new Message.fromJson(data['data'][i]));
              setState(() {});
            }
          } else {
            setState(() {
              _error = data['error'];
              socket.close();
              new Alert(
                  context: context,
                  title: "Errore",
                  body: Text(data['error']),
                  closeButton: true,
                  textCanelButton: "",
                  textConfirmButton: "Ok",
                  onClick: () {
                    Navigator.pushNamed(context, '/chats');
                  });
            });
          }
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
            children: [
              //TODO: aggiungere immagina del profilo stile WhatsApp
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
                reverse: false,
                padding: EdgeInsets.only(top: 10, bottom: 15),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _Message(
                      _messages[index].text,
                      /*('Oggi 10:$index'),*/
                      (_messages[index].userId == Main.client.id
                          ? false
                          : true));
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
                    String message = _textController.text;
                    setState(() {
                      _messages.add(new Message(
                          id: null,
                          text: message,
                          userId: Main.client.id,
                          date: new DateTime.now().toString()));
                    });
                    _textController.clear();
                    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
                      socket.write('' + json.encode({
                        "event": "message",
                        "client": Main.client,
                        "chatId": widget._chatId,
                        "peerId": widget._peerId,
                        "data": {
                          "text": message,
                        }
                      }));
                    });
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
