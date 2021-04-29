import 'package:floor/floor.dart';

@entity
class RoomFloor {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String identificator;

  RoomFloor(this.id, this.identificator);
}
