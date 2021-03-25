import 'package:floor/floor.dart';

@entity
class MemoCategory {
  @PrimaryKey(autoGenerate: true)
  int _id;
  String _name;
  String _description;
  String _creationDate;
  String _lastModifiedDate;

  MemoCategory(
      {int id,
      String name,
      String description,
      String creationDate,
      String lastModifiedDate}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._creationDate = creationDate;
    this._lastModifiedDate = lastModifiedDate;
  }
}
