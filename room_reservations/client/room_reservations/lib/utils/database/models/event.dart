import 'package:floor/floor.dart';

@entity
class Event {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String dateFrom;
  final String dateTo;
  final int teacherId;
  final int schoolClassId;
  final int roomId;

  Event(
      this.id,
      this.dateFrom,
      this.dateTo,
      this.teacherId,
      this.schoolClassId,
      this.roomId);
}