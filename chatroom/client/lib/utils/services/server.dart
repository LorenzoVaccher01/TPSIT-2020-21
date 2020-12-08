import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../main.dart' as Main;

class ServerConnection {
  Socket _socket;
  bool _connected = false;

  ServerConnection() {}

  get connected => _connected;

  Future<dynamic> connect() async {
    _socket = await Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT);/*.then((socket) {
      _socket = socket;
      _connected = true;
      print('OK!');
    });*/
    print('pippo');
    _connected = true;
  }

  Stream addStream() {
    Stream stream;
    _socket.addStream(stream);
    return stream;
  }

  void removeStream(Stream stream) { //TODO
  }

  void sendData(dynamic data, {bool convertToJson}) {
    _socket.write(convertToJson ? json.encode(data) : data);
  }

}