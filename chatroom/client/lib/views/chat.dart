import '../utils/models/chats.dart';
import '../widget/alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import '../main.dart' as Main;

class ChatPage extends StatefulWidget {
  final List<Users> _peers;
  final bool _isGroup;
  final int _chatId;
  final int _peerImageId;
  final String _peerName;
  final String _peerSurname;

  ChatPage(this._chatId, this._isGroup, this._peers, this._peerImageId,
      this._peerName, this._peerSurname);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  List<Message> _messages = [];
  String _error = "";
  Socket _socket;

  @override
  void initState() {
    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
      var data = {
        "event": "chat",
        "peers": widget._peers,
        "chatId": widget._chatId,
        "client": Main.client.toJson()
      };

      _socket = socket;

      /// send data
      socket.write('' + json.encode(data));

      /// listen data
      socket.listen((event) {
        var data = json.decode(utf8.decode(event));
        if (data['event'] == 'message') {
          if (data['status'] == 200) {
            if (data['data']['chatId'] == widget._chatId) {
              setState(() {
                _messages.insert(
                    0,
                    new Message(
                        id: data['data']['id'],
                        text: data['data']['message'],
                        userId: data['data']['client']['id'],
                        date: data['data']['date'],
                        sender: new Sender(
                          id: data['data']['client']['id'],
                          name: data['data']['client']['name']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              data['data']['client']['name']
                                  .toString()
                                  .substring(1),
                          surname: data['data']['client']['surname']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              data['data']['client']['surname']
                                  .toString()
                                  .substring(1),
                          nickname: data['data']['client']['nickname'],
                          imageId: data['data']['client']['imageId'],
                        )));
              });
              _scrollController.animateTo(
                0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          } else {
            _error = data['error'];
            socket
                .write('' + json.encode({"event": "end", " position": "chat"}));
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
          }
        }

        if (data['event'] == 'chat') {
          if (data['status'] == 200) {
            for (var i = 0; i < data['data'].length; i++) {
              _messages.add(new Message.fromJson(data['data'][i]));
              setState(() {});
            }
          } else {
            setState(() {
              _error = data['error'];
              socket.write(
                  '' + json.encode({"event": "end", " position": "chat"}));
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
  void deactivate() {
    _socket.write('' + json.encode({"event": "end", " position": "chat"}));
    _socket.close();
    super.deactivate();
  }

  @override
  void dispose() {
    _socket.write('' + json.encode({"event": "end", " position": "chat"}));
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset(
                'assets/avatars/${widget._peerImageId}.png',
                width: 50,
                height: 40,
              ),
            ),
            Column(
              children: [
                Text('${widget._peerName} ${widget._peerSurname}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Visibility(
                  visible: widget._isGroup,
                  child: Text("${widget._peers.length} utenti", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                )
              ],
            ),
          ],
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              _socket.write(
                  '' + json.encode({"event": "end", " position": "chat"}));
              _socket.close();
              Navigator.pushNamed(context, '/chats');
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFE5DDD5),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                reverse: true,
                padding: EdgeInsets.only(top: 10, bottom: 15),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _Message(
                      _messages[index].text,
                      _messages[index].date,
                      widget._isGroup,
                      _messages[index].sender,
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
                    if (message != null && message != '') {
                      setState(() {
                        _messages.insert(
                            0,
                            new Message(
                                id: null,
                                text: message,
                                userId: Main.client.id,
                                date: new DateTime.now().subtract(Duration(hours: 1)).toString(),
                                sender: new Sender(
                                    id: Main.client.id,
                                    name: Main.client.name,
                                    surname: Main.client.surname,
                                    nickname: Main.client.nickname,
                                    imageId: Main.client.imageId)));
                      });
                      _textController.clear();
                      _scrollController.animateTo(
                        0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                      Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT)
                          .then((socket) {
                        socket.write('' +
                            json.encode({
                              "event": "message",
                              "client": Main.client,
                              "chatId": widget._chatId,
                              "peers": widget._peers,
                              "data": {
                                "message": message,
                              }
                            }));
                        //Timer(Duration(seconds: 2), () => socket.write('' + json.encode({"event": "end", " position": "message"})));
                        socket.close();
                      });
                    }
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
  final String _date;
  final Sender _sender;
  final bool _isPeer;
  final bool _isGroup;

  _Message(
      this._message, this._date, this._isGroup, this._sender, this._isPeer);

  String _getDate(String date) {
    DateTime today = DateTime.now();
    DateTime dateTime = DateTime.parse(date).add(Duration(hours: 1));

    if (today.difference(dateTime).inDays == 1)
      return "Ieri ${dateTime.hour}:${dateTime.minute}";
    else if (today.difference(dateTime).inDays > 1)
      return "${dateTime.day}/${dateTime.month}/${dateTime.year.toString().substring(2)} ${dateTime.hour}:${dateTime.minute}";
    else
      return "${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: _isGroup && _isPeer,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Image.asset(
              'assets/avatars/${_sender.imageId}.png',
              height: 40,
              width: 40,
            ),
          ),
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                color: _isPeer ? Color(0xFFFFFFFF) : Color(0xFFdcf8c6),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(
                  top: 15,
                  left: (_isPeer ? 10 : 80),
                  right: (_isPeer ? 80 : 20)),
              padding: EdgeInsets.all(10),
              child: _buildContainer()),
        )
      ],
    );
  }

  Widget _buildContainer() {
    if (_isGroup)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _isPeer,
            child: Text(
              _sender.name + ' ' + _sender.surname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Visibility(
            visible: _isPeer,
            child: Padding(
              padding: EdgeInsets.only(bottom: 0),
            ),
          ),
          Text(_message, style: TextStyle(color: Colors.black, fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  "${_getDate(_date)}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          )
        ],
      );
    else
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_message, style: TextStyle(color: Colors.black, fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  "${_getDate(_date)}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          )
        ],
      );
  }
}
