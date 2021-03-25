import 'package:floor/floor.dart';

@entity
class MemoAccountAssociation {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int memoId;
  final int accountId;
  final bool isOwner;
  final int permission;

  MemoAccountAssociation(this.id, this.memoId, this.accountId, this.isOwner, this.permission);
}