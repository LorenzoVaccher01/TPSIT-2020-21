import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/teacher.dart';

@dao
abstract class TeacherDao {
  @Query("SELECT * FROM Teacher")
  Future<List<Teacher>> findAllTeacher();
}
