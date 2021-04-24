import 'package:floor/floor.dart';

@entity
class SchoolClass {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String section;
  final int year;

  SchoolClass(this.id, this.section, this.year);
}
