import 'package:flutter/material.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:shared_preferences/shared_preferences.dart';

class Client {
  int _id;
  String _name;
  String _email;
  String _sessionCookie;
  String _imagePath;
  String _uid;

  Client(
      {int id,
      String imagePath,
      bool getSession = false,
      @required String name,
      @required String email,
      @required String sessionCookie,
      @required String uid}) {
    this._id = id;
    this._imagePath = imagePath;
    this._name = name;
    this._email = email;
    this._sessionCookie = sessionCookie;
    this._uid = uid;

    if (getSession) this._sessionCookie = getSessionId();
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get sessionCookie => _sessionCookie;
  String get imagePath => _imagePath;
  String get uid => _uid;

  String getSessionId() {
    return "";
  }

  static Future<bool> isLogged() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String cookie = _prefs.getString('user.sessionCookie');

    if (cookie != null) {
      const Map<String, int> monthsInYear = {
        "Jan": 1,
        "Feb": 2,
        "Mar": 3,
        "Apr": 4,
        "May": 5,
        "Jun": 6,
        "Jul": 7,
        "Aug": 8,
        "Sep": 9,
        "Oct": 10,
        "Nov": 11,
        "Dec": 12
      };

      var date = cookie
          .split(';')[cookie.split(';').length - 2]
          .split('=')[1]
          .split(',')[1]
          .split(' ');

      DateTime cookieDate = DateTime(
          int.parse(date[3]),
          monthsInYear[date[2]],
          int.parse(date[1]),
          int.parse(date[4].split(':')[0]),
          int.parse(date[4].split(':')[1]),
          int.parse(date[4].split(':')[2]));

      if (cookieDate.isAfter(DateTime.now())) {
        App.client = new Client(
            id: _prefs.getInt('user.id'),
            name: _prefs.getString('user.name'),
            email: _prefs.getString('user.email'),
            sessionCookie: _prefs.getString('user.sessionCookie'),
            uid: _prefs.getString('user.uid'));
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['sessionCookie'] = this._sessionCookie;
    data['imagePath'] = this._imagePath;
    return data;
  }
}
