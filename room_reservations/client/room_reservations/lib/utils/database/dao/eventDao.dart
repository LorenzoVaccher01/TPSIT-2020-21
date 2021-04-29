import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/event.dart';

@dao
abstract class EventDao {
  @Query("SELECT * FROM Event")
  Future<List<EventFloor>> getAllEvents();
  
  @Query("SELECT * FROM Event WHERE id= :id")
  Future<EventFloor> getEventById(int id);

  @Query("DELETE FROM Event WHERE id= :id")
  Future<void> deleteEventById(int id);

  @delete
  Future<void> deleteEvent(EventFloor event);

  @insert
  Future<void> insertEvent(EventFloor event);
}