import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/teacher.dart';

@dao
abstract class TeacherDao {
  @Query("SELECT * FROM Teacher")
  Future<List<TeacherFloor>> getAllTeachers();

  @Query("SELECT * FROM Teacher WHERE id= :id")
  Future<TeacherFloor> getTeacherById(int id);

  @Query("DELETE FROM Teacher WHERE id= :id")
  Future<void> deleteTeacherById(int id);

  @delete
  Future<void> deleteTeacher(TeacherFloor teacher);

  @insert
  Future<void> insertTeacher(TeacherFloor teacher);
}
