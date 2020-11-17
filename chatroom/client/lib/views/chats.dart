import 'package:client/utils/models/chats.dart';
import 'package:client/utils/services/server.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import './chat.dart';
import '../main.dart' as Main;

class ChatsPage extends StatefulWidget {
  ChatsPage();

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<Chat> _chats = [];
  Stream _stream;

  @override
  void initState() {
    _stream = new ServerConnection().chats(Main.client);

    _chats.add(new Chat(id: 1, imageId: 4, name: "Tommaso", surname: "Rizzo", message: new Message(text: "Ciao a tutti! io sono Rizzo", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 2, imageId: 10, name: "Giacomo", surname: "Davanzo", message: new Message(text: "Lorem ipsum!", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 3, imageId: 16, name: "Jia Hao", surname: "Ruan", message: new Message(text: "Ciao, questo è un test molto testoso!", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 4, imageId: 18, name: "Elia", surname: "Corò", message: new Message(text: "Pippo palla", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 5, imageId: 24, name: "Valentin", surname: "Necula", message: new Message(text: "Ciccio palla02 sahsb1 '0123 asjkhd", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 6, imageId: 30, name: "Tommaso", surname: "Fassina", message: new Message(text: "Mi chiamo Tommaso Fassina!!!", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 7, imageId: 16, name: "Marco", surname: "Zanocco", message: new Message(text: "Ciao a tutti, questo è un test molto testoso!!!!!!!!!!!!!!", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 8, imageId: 18, name: "Marco", surname: "Piazzon", message: new Message(text: "la alai ashd asiudh qwieuh adsiuhas daiousdhqw 9quwey asodih awoiuhas doiihqw eoasjhd", date: "2020-11-12 17:58:39")));
    _chats.add(new Chat(id: 9, imageId: 1, name: "Carlo", surname: "Mavaracchio", message: new Message(text: "kjasd aiusdhqwuieh asiduhac kxjcna sipuwhe kshdiuqw oiusd", date: "2020-11-12 17:58:39")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder<Object>(
                stream: _stream,
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none: print('NONE'); break;
                      case ConnectionState.waiting: print('WAITING'); break;
                      case ConnectionState.active: print('ACTIVE'); break;
                      case ConnectionState.done: print('DONE'); break;
                    }
                  }
                  return ListView.separated(
                    reverse: false,
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    itemCount: _chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell( ///Widget utilizzato come GestureDetector, con l'unica differenza che prende il 100% della lunghezza del contenitore e non solo la lunghezza dei Widget
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: _Chat(_chats[index].id, _chats[index].name, _chats[index].surname, _chats[index].message.text, _chats[index].imageId),
                        ),
                        onTap: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(1, _chats[index].name, _chats[index].surname)))
                        }
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 0.4,
                      indent: 70,
                      endIndent: 15,
                    ),
                  );
                }
              ),
            ),
          ),
        ],
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

  _Chat(this._id, this._name, this._surname, this._message, this._imageId);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<_Chat> {
  
  /// Metodo utilizzato per troncare il messaggio dopo tot 
  /// caratteri per evitare overflow del testo.
  String _cutMessage(String message) {
    if (message.length <= 35)
      return message;
    else
      return message.substring(0, 35) + '...';
  }

  @override
  Widget build(BuildContext context) {
    var val = new Random().nextInt(30);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 15),
          child: Image.asset("assets/avatars/${val + 1}.png",
              width: 55, height: 55),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "${widget._name} ${widget._surname}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ),
              Text(
                _cutMessage(widget._message),
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
