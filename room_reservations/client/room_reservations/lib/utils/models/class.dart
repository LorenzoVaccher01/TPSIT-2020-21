import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:http/http.dart' as http;
import 'package:room_reservations/widget/alert.dart';

class SchoolClass {
  int _id;
  String _section;
  int _year;

  SchoolClass({int id, String section, int year}) {
    this._id = id;
    this._section = section;
    this._year = year;
  }

  int get id => _id;
  String get section => _section;
  int get year => _year;

  static Future<List<SchoolClass>> get(BuildContext context) async {
    List<SchoolClass> _schoolClasses = [];

    try {
      if (App.isConnected) {
        final serverResponse = await http.get(
          Uri.parse(App.SERVER_WEB + '/api/classes'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': App.client.sessionCookie
          },
        );

        if (serverResponse.statusCode == 200) {
          final bodyResponse = json.decode(serverResponse.body);
          if (bodyResponse['status'] == 200) {
            bodyResponse['data'].forEach((item) {
              _schoolClasses.add(SchoolClass.fromJson(item));
            });
            return _schoolClasses;
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

  SchoolClass.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _section = json['section'];
    _year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['section'] = this._section;
    data['year'] = this._year;
    return data;
  }
}
