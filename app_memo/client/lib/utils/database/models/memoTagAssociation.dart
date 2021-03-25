import 'package:floor/floor.dart';

@entity
class MemoTagAssociation {
  @PrimaryKey(autoGenerate: true)
  int _id;
  int _memoId;
  int _tagId;

  MemoTagAssociation(this._id, this._memoId, this._tagId);
}