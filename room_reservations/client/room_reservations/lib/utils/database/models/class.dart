import 'package:floor/floor.dart';

@entity
class SchoolClassFloor {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String section;
  final int year;

  SchoolClassFloor(this.id, this.section, this.year);
}
