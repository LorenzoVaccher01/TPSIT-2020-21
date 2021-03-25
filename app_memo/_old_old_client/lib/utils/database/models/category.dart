import 'package:floor/floor.dart';

@entity
class MemoCategory {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String description;
  final String creationDate;
  final String lastModifiedDate;

  MemoCategory(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
      this.lastModifiedDate});
}
