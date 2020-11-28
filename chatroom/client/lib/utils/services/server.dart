import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../main.dart' as Main;

class ServerConnection {
  Socket _socket;
  bool _connected = false;

  ServerConnection() {
    print('ASD!');
    Socket.connect(Main.SOCKET_IP, Main.SOCKET_PORT).then((socket) {
      _socket = socket;
      _connected = true;
      print('OK!');
    });
  }

  get connected => _connected;

  Stream addStream() {
    Stream stream;
    _socket.addStream(stream);
    return stream;
  }

  void sendData(dynamic data, {bool convertToJson}) {
    _socket.write(convertToJson ? json.encode(data) : data);
  }

}