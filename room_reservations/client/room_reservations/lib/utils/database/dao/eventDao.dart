import 'package:floor/floor.dart';
import 'package:room_reservations/utils/database/models/event.dart';

@dao
abstract class EventDao {
  @Query("SELECT * FROM Event")
  Future<List<Event>> findAllEvent();
  
}