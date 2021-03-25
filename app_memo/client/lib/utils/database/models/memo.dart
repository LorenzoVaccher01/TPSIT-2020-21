import 'package:floor/floor.dart';

@entity
class Memo {
  @PrimaryKey(autoGenerate: true)
  int _id;
  bool _isOwner;
  int _permission;
  String _title;
  String _color;
  String _body;
  String _creationDate;
  String _lastModifiedDate;
  int _categoryId;

  Memo(
      {int id,
      bool isOwner,
      int permission,
      String title,
      String color,
      String body,
      String creationDate,
      String lastModifiedDate,
      int categoryId}) {
    this._id = id;
    this._isOwner = isOwner;
    this._permission = permission;
    this._title = title;
    this._color = color;
    this._body = body;
    this._creationDate = creationDate;
    this._lastModifiedDate = lastModifiedDate;
    this._categoryId = categoryId;
  }
}
