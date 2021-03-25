import 'package:floor/floor.dart';

@entity
class FloorMemo {
  @PrimaryKey(autoGenerate: true)
  int id;
  bool isOwner;
  int permission;
  String title;
  String color;
  String body;
  String creationDate;
  String lastModifiedDate;
  int categoryId;

  FloorMemo(
      {this.id,
      this.isOwner,
      this.permission,
      this.title,
      this.color,
      this.body,
      this.creationDate,
      this.lastModifiedDate,
      this.categoryId});
}
