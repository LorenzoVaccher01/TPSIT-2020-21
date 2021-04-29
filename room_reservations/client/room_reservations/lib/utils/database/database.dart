import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/dao/classDao.dart';
import 'package:room_reservations/utils/database/dao/eventDao.dart';
import 'package:room_reservations/utils/database/dao/roomDao.dart';
import 'package:room_reservations/utils/database/dao/teacherDao.dart';
import 'package:room_reservations/utils/database/models/class.dart';
import 'package:room_reservations/utils/database/models/event.dart';
import 'package:room_reservations/utils/database/models/room.dart';
import 'package:room_reservations/utils/database/models/teacher.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';


// flutter packages pub run build_runner build --delete-conflicting-outputs

part 'database.g.dart';
@Database(version: 1, entities: [
  EventFloor,
  TeacherFloor,
  SchoolClassFloor,
  RoomFloor
])

abstract class AppDatabase extends FloorDatabase {
  TeacherDao get teacherDao;
  SchoolClassDao get schoolClassDao;
  RoomDao get roomDao;
  EventDao get eventDao;
}