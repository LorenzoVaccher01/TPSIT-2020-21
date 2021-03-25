import 'package:floor/floor.dart';

@entity
class MemoTag {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String description;
  final String creationDate;
  final String lastModifiedDate;

  MemoTag(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
      this.lastModifiedDate});
}
