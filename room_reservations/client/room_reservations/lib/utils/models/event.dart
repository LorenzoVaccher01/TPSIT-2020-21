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
import 'package:room_reservations/utils/database/models/event.dart';
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
  String get dateFrom => _dateFrom;
  String get dateTo => _dateTo;
  Teacher get teacher => _teacher;
  SchoolClass get schoolClass => _schoolClass;
  Room get room => _room;

  static Future<List<Event>> get(BuildContext context, DateTime date, String sorting) async {
    List<Event> _events = [];

    String dateFormat = date.year.toString() +
        "-" +
        date.month.toString().padLeft(2, "0") +
        "-" +
        date.day.toString().padLeft(2, "0");

    try {
      if (App.isConnected) {
        final serverResponse = await http.get(
          Uri.parse(App.SERVER_WEB + '/api/events?date=' + dateFormat + '&sorting=' + sorting),
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
        //TODO: verificare il tipo di sorting

        /*final database =
            await $FloorAppDatabase.databaseBuilder(App.DATABASE_NAME).build();
        final eventDao = database.eventDao;

        List<EventFloor> _dbEvents = await eventDao.getAllEvents();
        print(_dbEvents);*/
        return [
          //new Event(1, ""),
        ];
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

  static Future<void> add(BuildContext context,
      {@required String teacher,
      @required String schoolClass,
      @required String room,
      @required String day,
      @required String dateFrom,
      @required String dateTo}) async {
    try {
      final serverResponse = await http.post(
          Uri.parse(App.SERVER_WEB + '/api/event'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': App.client.sessionCookie
          },
          body: json.encode({
            "teacher": teacher,
            "schoolClass": schoolClass,
            "room": room,
            "day": day,
            "dateFrom": dateFrom,
            "dateTo": dateTo
          }));

      if (serverResponse.statusCode == 200) {
        final bodyResponse = json.decode(serverResponse.body);
        if (bodyResponse['status'] == 200) {
          //TODO: aggiungere l'evento nel database in locale con l'id specificato sotto
          final int eventId = bodyResponse['data']['eventId'];
          print(eventId);
        } else {
          throw (bodyResponse['message']);
        }
      } else {
        throw ("Internal server errror");
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
    }
  }

  Future<void> remove(int id) {
    
  }

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
