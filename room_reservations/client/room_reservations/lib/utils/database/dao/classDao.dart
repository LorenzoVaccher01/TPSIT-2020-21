import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/class.dart';

@dao
abstract class SchoolClassDao {
  @Query("SELECT * FROM SchoolClass")
  Future<List<SchoolClassFloor>> getAllSchoolClass();

  @Query("SELECT * FROM SchoolClass WHERE id= :id")
  Future<SchoolClassFloor> getSchoolClassById(int id);

  @Query("DELETE FROM SchoolClass WHERE id= :id")
  Future<void> deleteSchoolClassById(int id);

  @delete
  Future<void> deleteSchoolClass(SchoolClassFloor schoolClass);

  @insert
  Future<void> insertSchoolClass(SchoolClassFloor schoolClass);
}
