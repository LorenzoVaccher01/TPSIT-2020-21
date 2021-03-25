import 'package:floor/floor.dart';

@entity
class MemoAccountAssociation {
  @PrimaryKey(autoGenerate: true)
  int _id;
  int _memoId;
  int _accountId;
  bool _isOwner;
  int _permission;

  MemoAccountAssociation(this._id, this._memoId, this._accountId, this._isOwner, this._permission);
}