
// {
//     "dateFrom": "",
//     "dateTo": "",
//     "teacher": {
//         "name": "asd",
//         "surname": "asd",
//         "email": "asd",
//         "concourseClass": "A"
//     },
//     "class": {
//         "id": 1,
//         "section": "IC",
//         "year": 5
//     },
//     "room": {
//         "id": 1,
//         "identificator": "Aula-22"
//     }
// }
import 'package:room_reservations/utils/models/class.dart';
import 'package:room_reservations/utils/models/room.dart';
import 'package:room_reservations/utils/models/teacher.dart';

class Event {
	String _dateFrom;
	String _dateTo;
	Teacher _teacher;
	Class _schoolClass;
	Room _room;

	Event({String dateFrom, String dateTo, Teacher teacher, Class schoolClass, Room room}) {
this._dateFrom = dateFrom;
this._dateTo = dateTo;
this._teacher = teacher;
this._schoolClass = schoolClass;
this._room = room;
}

	String get dateFrom => _dateFrom;
	set dateFrom(String dateFrom) => _dateFrom = dateFrom;
	String get dateTo => _dateTo;
	set dateTo(String dateTo) => _dateTo = dateTo;
	Teacher get teacher => _teacher;
	set teacher(Teacher teacher) => _teacher = teacher;
	Class get schoolClass => _schoolClass;
	set schoolClass(Class schoolClass) => _schoolClass = schoolClass;
	Room get room => _room;
	set room(Room room) => _room = room;

	Event.fromJson(Map<String, dynamic> json) {
		_dateFrom = json['dateFrom'];
		_dateTo = json['dateTo'];
		_teacher = json['teacher'] != null ? new Teacher.fromJson(json['teacher']) : null;
		_schoolClass = json['class'] != null ? new Class.fromJson(json['class']) : null;
		_room = json['room'] != null ? new Room.fromJson(json['room']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['dateFrom'] = this._dateFrom;
		data['dateTo'] = this._dateTo;
		if (this._teacher != null) {
      data['teacher'] = this._teacher.toJson();
    }
		if (this._schoolClass != null) {
      data['class'] = this._schoolClass.toJson();
    }
		if (this._room != null) {
      data['room'] = this._room.toJson();
    }
		return data;
	}
}