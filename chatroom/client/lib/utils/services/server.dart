
import 'dart:convert';

import '../../main.dart' as Main;
import 'package:web_socket_channel/io.dart';

class ServerConnection {
  IOWebSocketChannel _channel;

  ServerConnection() {
    this._channel = IOWebSocketChannel.connect(Main.SOCKET_URL);
  }

  /// Metodo utilizzato per effettuare il login da parte di un utente.
  Future<Map<String, int>> login({String nickname, String password}) {
    var data = {};
    data['nickname'] = nickname;
    data['password'] = password;
    this._channel.sink.add('[login]' + json.encode(data));
    this._channel.stream.listen((event) async { 
      print(event);
      return await json.decode(event);
    });
  }
}