import 'package:floor/floor.dart';

@entity
class FloorTag {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String description;
  final String creationDate;
  final String lastModifiedDate;

  FloorTag(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
      this.lastModifiedDate});
}
