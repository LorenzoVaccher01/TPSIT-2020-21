import 'package:floor/floor.dart';

@entity
class Room {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String identificator;

  Room(this.id, this.identificator);
}
