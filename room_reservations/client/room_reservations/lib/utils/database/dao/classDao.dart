import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/class.dart';

@dao
abstract class SchoolClassDao {
  @Query("SELECT * FROM SchoolClass")
  Future<List<SchoolClass>> findAllSchoolClass();
}
