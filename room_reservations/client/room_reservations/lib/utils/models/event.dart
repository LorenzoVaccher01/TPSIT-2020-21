// {
//     "id": 12,
//     "dateFrom": "",
//     "dateTo": "",
//     "teacher": {
//         "id": 1,
//         "name": "asd",
//         "surname": "asd",
//         "email": "asd",
//         "concourseClass": "A",
//         "profileImage": "asd"
//     },
//     "schoolClass": {
//         "id": 1,
//         "section": "IC",
//         "year": 5
//     },
//     "room": {
//         "id": 1,
//         "identificator": "Aula-22"
//     }
// }

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/database/database.dart';
import 'package:room_reservations/utils/models/class.dart';
import 'package:room_reservations/utils/models/room.dart';
import 'package:room_reservations/utils/models/teacher.dart';
import 'package:room_reservations/widget/alert.dart';

class Event {
  int _id;
  String _dateFrom;
  String _dateTo;
  Teacher _teacher;
  SchoolClass _schoolClass;
  Room _room;

  Event(
      {int id,
      String dateFrom,
      String dateTo,
      Teacher teacher,
      SchoolClass schoolClass,
      Room room}) {
    this._id = id;
    this._dateFrom = dateFrom;
    this._dateTo = dateTo;
    this._teacher = teacher;
    this._schoolClass = schoolClass;
    this._room = room;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get dateFrom => _dateFrom;
  set dateFrom(String dateFrom) => _dateFrom = dateFrom;
  String get dateTo => _dateTo;
  set dateTo(String dateTo) => _dateTo = dateTo;
  Teacher get teacher => _teacher;
  set teacher(Teacher teacher) => _teacher = teacher;
  SchoolClass get schoolClass => _schoolClass;
  set schoolClass(SchoolClass schoolClass) => _schoolClass = schoolClass;
  Room get room => _room;
  set room(Room room) => _room = room;

  static Future<List<Event>> get(BuildContext context, DateTime date) async {
    List<Event> _events = [];

    String dateFormat = date.year.toString() +
        "-" +
        date.month.toString().padLeft(2, "0") +
        "-" +
        date.day.toString().padLeft(2, "0");

    try {
      if (App.isConnected) {
        final serverResponse = await http.get(
          Uri.parse(App.SERVER_WEB + '/api/events?date=' + dateFormat),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': App.client.sessionCookie
          },
        );

        if (serverResponse.statusCode == 200) {
          final bodyResponse = json.decode(serverResponse.body);
          if (bodyResponse['status'] == 200) {
            bodyResponse['data'].forEach((item) {
              _events.add(Event.fromJson(item));
            });
            return _events;
          } else {
            throw (bodyResponse['message']);
          }
        } else {
          throw ("Internal server errror");
        }
      } else {
        //TODO: prendere i dati dal database in locale

        final database =
            await $FloorAppDatabase.databaseBuilder(App.DATABASE_NAME).build();
        final eventDao = database.eventDao;
        _events = (await eventDao.findAllEvent()).cast<Event>();
        print(_events);
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

  Future<void> add(Event event) {}

  Future<void> remove(Event event) {}

  Event.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _dateFrom = json['dateFrom'];
    _dateTo = json['dateTo'];
    _teacher =
        json['teacher'] != null ? new Teacher.fromJson(json['teacher']) : null;
    _schoolClass = json['schoolClass'] != null
        ? new SchoolClass.fromJson(json['schoolClass'])
        : null;
    _room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['dateFrom'] = this._dateFrom;
    data['dateTo'] = this._dateTo;
    if (this._teacher != null) {
      data['teacher'] = this._teacher.toJson();
    }
    if (this._schoolClass != null) {
      data['schoolClass'] = this._schoolClass.toJson();
    }
    if (this._room != null) {
      data['room'] = this._room.toJson();
    }
    return data;
  }
}
