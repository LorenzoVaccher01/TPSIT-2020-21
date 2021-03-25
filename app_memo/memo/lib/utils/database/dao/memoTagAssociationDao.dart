import 'package:floor/floor.dart';
import '../models/memoTagAssociation.dart';

@dao
abstract class MemoTagAssociationDao {
  @Query('SELECT * FROM FloorMemoTagAssociation WHERE memoId = :memoId')
  Future<FloorMemoTagAssociation> findTagByMemoId(int memoId);

  @Query('SELECT * FROM FloorMemoTagAssociation WHERE tagId = :tagId')
  Future<FloorMemoTagAssociation> findTagByTagId(int tagId);

  @delete
  Future<void> deleteMemoAccountAssociation(
      FloorMemoTagAssociation memoTagAssociation);

  @update
  Future<void> updateMemoAccountAssociation(
      FloorMemoTagAssociation memoTagAssociation);

  @insert
  Future<void> insertMemoAccountAssociation(
      FloorMemoTagAssociation memoTagAssociation);
}
