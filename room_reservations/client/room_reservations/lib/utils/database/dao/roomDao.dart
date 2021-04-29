import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/room.dart';

@dao
abstract class RoomDao {
  @Query("SELECT * FROM Room")
  Future<List<RoomFloor>> getAllRooms();

  @Query("SELECT * FROM Room WHERE id= :id")
  Future<RoomFloor> getRoomById(int id);

  @Query("DELETE FROM Room WHERE id= :id")
  Future<void> deleteRoomById(int id);

  @delete
  Future<void> deleteRoom(RoomFloor room);

  @insert
  Future<void> insertRoom(RoomFloor room);
}
