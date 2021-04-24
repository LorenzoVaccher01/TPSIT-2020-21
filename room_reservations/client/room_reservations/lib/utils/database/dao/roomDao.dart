import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/room.dart';

@dao
abstract class RoomDao {
  @Query("SELECT * FROM Room")
  Future<List<Room>> findAllRoom();
}
