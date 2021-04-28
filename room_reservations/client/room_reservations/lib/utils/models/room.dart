import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:http/http.dart' as http;
import 'package:room_reservations/widget/alert.dart';

class Room {
  int _id;
  String _identificator;

  Room({int id, String identificator}) {
    this._id = id;
    this._identificator = identificator;
  }

  int get id => _id;
  String get identificator => _identificator;

  static Future<List<Room>> get(BuildContext context) async {
    List<Room> _rooms = [];
    try {
      if (App.isConnected) {
        final serverResponse = await http.get(
          Uri.parse(App.SERVER_WEB + '/api/rooms'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': App.client.sessionCookie
          },
        );

        if (serverResponse.statusCode == 200) {
          final bodyResponse = json.decode(serverResponse.body);
          if (bodyResponse['status'] == 200) {
            bodyResponse['data'].forEach((item) {
              _rooms.add(Room.fromJson(item));
            });
            return _rooms;
          } else {
            throw (bodyResponse['message']);
          }
        } else {
          throw ("Internal server errror");
        }
      } else {
        return [];
      }
    } catch (e) {
      Alert(
          context: context,
          title: 'Error!',
          closeButton: false,
          textConfirmButton: 'Ok',
          body: Text(e.toString()),
          textCanelButton: "",
          onClick: () {});
      return [];
    }
  }

  Room.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _identificator = json['identificator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['identificator'] = this._identificator;
    return data;
  }
}
