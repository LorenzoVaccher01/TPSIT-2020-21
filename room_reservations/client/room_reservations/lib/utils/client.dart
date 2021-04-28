import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:http/http.dart' as http;
import 'package:room_reservations/utils/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Client {
  int _id;
  bool _isAdmin;
  String _name;
  String _email;
  String _sessionCookie;
  String _imagePath;
  String _uid;

  Client(
      {int id,
      String imagePath,
      bool isAdmin = false,
      @required String name,
      @required String email,
      String sessionCookie,
      @required String uid}) {
    this._id = id;
    this._imagePath = imagePath;
    this._isAdmin = isAdmin;
    this._name = name;
    this._email = email;
    this._sessionCookie = sessionCookie;
    this._uid = uid;
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get sessionCookie => _sessionCookie;
  String get imagePath => _imagePath;
  String get uid => _uid;
  bool get isAdmin => _isAdmin;

  set sessionCookie(String sessionCookie) => _sessionCookie = sessionCookie;

  Future<String> getSessionCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final User user = FirebaseAuth.instance.currentUser;
    final String fcmToken = await FirebaseMessaging.instance.getToken();
    final String token = await user.getIdToken(true);

    final response = await http.post(Uri.parse(App.SERVER_WEB + '/login'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "{\"token\":\"" + token + "\", \"fcmToken\": \"" + fcmToken + "\"}");
    
    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        this._isAdmin = bodyResponse['isAdmin'];
        prefs.setBool("user.isAdmin", bodyResponse['isAdmin']);
        prefs.setString("user.sessionCookie", response.headers['set-cookie']);
        return response.headers['set-cookie'];
      } else {
        throw (bodyResponse['message']);
      }
    } else {
      throw ("Internal server error");
    }
  }

  static Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookie = prefs.getString('user.sessionCookie');
    User currentUser = FirebaseAuth.instance.currentUser;

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

      if (currentUser != null) {
        if (cookieDate.isAfter(DateTime.now())) {
          App.client = new Client(
              name: currentUser.displayName,
              email: currentUser.email,
              isAdmin: prefs.getBool('user.isAdmin') ?? false,
              sessionCookie: prefs.getString('user.sessionCookie'),
              uid: currentUser.uid,
              imagePath: currentUser.photoURL);
          return true;
        } else {
          // viene eseguito il logout dell'utente, così potrà effettuare nuovamente
          // l'accesso e ottenere una nuova sessione
          await Auth.googleSignout();
          return false;
        }
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
