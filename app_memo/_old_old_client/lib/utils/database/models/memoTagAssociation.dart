import 'package:floor/floor.dart';

@entity
class MemoTagAssociation {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int memoId;
  final int tagId;

  MemoTagAssociation(this.id, this.memoId, this.tagId);
}