
import 'dart:convert';

import '../../main.dart' as Main;
import '../client.dart';
import 'package:web_socket_channel/io.dart';

class ServerConnection extends Messanger {
  IOWebSocketChannel _channel;

  ServerConnection() {
    this._channel = IOWebSocketChannel.connect(Main.SOCKET_IP);
  }

  IOWebSocketChannel get channel => this._channel;

  /// Metodo utilizzato per effettuare il login da parte di un utente.
  Stream<dynamic> login({String nickname, String password}) {
    var data = {};
    data['nickname'] = nickname;
    data['password'] = password;
    this._channel.sink.add('[login]' + json.encode(data));
    return this._channel.stream;
  }

  /// Metodo utilizzato per effettuare la registrazione di un utente.
  Stream<dynamic> registration({String name, String surname, String nickname, String password}) {
    this._channel.sink.add('[registration]' + json.encode({
      'name': name,
      'surname': surname,
      'nickname': nickname,
      'password': password
    }));
    return this._channel.stream;
  }

  Stream<dynamic> chats(Client client) {
    this._channel.sink.add('[chats]' + json.encode(client.toJson()));
    return this._channel.stream;
  }

}

class Messanger {

  void sendMessage() {

  }
}