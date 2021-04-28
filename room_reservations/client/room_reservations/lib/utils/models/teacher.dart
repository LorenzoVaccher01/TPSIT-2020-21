import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:http/http.dart' as http;
import 'package:room_reservations/widget/alert.dart';

class Teacher {
  int _id;
  String _name;
  String _email;
  String _concourseClass;
  String _profileImage;

  Teacher(
      {int id,
      String name,
      String email,
      String concourseClass,
      String profileImage}) {
    this._id = id;
    this._name = name;
    this._email = email;
    this._concourseClass = concourseClass;
    this._profileImage = profileImage;
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get concourseClass => _concourseClass;
  String get profileImage => _profileImage;

  static Future<List<Teacher>> get(BuildContext context) async {
    List<Teacher> _teachers = [];

    try {
      if (App.isConnected) {
        final serverResponse = await http.get(
          //TODO: verificare se nella session del server è presente il fatto che il client è un admin
          Uri.parse(App.SERVER_WEB + '/api/teachers'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': App.client.sessionCookie
          },
        );

        if (serverResponse.statusCode == 200) {
          final bodyResponse = json.decode(serverResponse.body);
          if (bodyResponse['status'] == 200) {
            bodyResponse['data'].forEach((item) {
              _teachers.add(Teacher.fromJson(item));
            });
            return _teachers;
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

  Teacher.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _concourseClass = json['concourseClass'];
    _profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['concourseClass'] = this._concourseClass;
    data['profileImage'] = this._profileImage;
    return data;
  }
}
