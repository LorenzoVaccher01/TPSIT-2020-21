import 'package:floor/floor.dart';

@entity
class Teacher {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String email;
  final String concourseClass;
  final String profileImage;

  Teacher(
      this.id,
      this.name,
      this.email,
      this.concourseClass,
      this.profileImage);
}
