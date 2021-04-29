import 'package:floor/floor.dart';

@entity
class TeacherFloor {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String email;
  final String concourseClass;
  final String profileImage;

  TeacherFloor(
      this.id,
      this.name,
      this.email,
      this.concourseClass,
      this.profileImage);
}
