import 'package:floor/floor.dart';

@entity
class EventFloor {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String dateFrom;
  final String dateTo;
  final int teacherId;
  final int schoolClassId;
  final int roomId;

  EventFloor(
      this.id,
      this.dateFrom,
      this.dateTo,
      this.teacherId,
      this.schoolClassId,
      this.roomId);
}