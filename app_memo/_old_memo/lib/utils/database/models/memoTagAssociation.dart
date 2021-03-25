import 'package:floor/floor.dart';

@entity
class FloorMemoTagAssociation {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int memoId;
  final int tagId;

  FloorMemoTagAssociation(this.id, this.memoId, this.tagId);
}