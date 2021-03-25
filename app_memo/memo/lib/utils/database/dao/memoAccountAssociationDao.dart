import 'package:floor/floor.dart';
import '../models/memoAccountAssociation.dart';

@dao
abstract class MemoAccountAssociationDao {

  @Query('SELECT * FROM FloorMemoAccountAssociation WHERE accountId = :accountId')
  Future<FloorMemoAccountAssociation> findMemoAccountAssociationByAccountId(int accountId);

  @Query('SELECT * FROM FloorMemoAccountAssociation WHERE memoId = :memoId')
  Future<FloorMemoAccountAssociation> findMemoAccountAssociationByMemoId(int memoId);

  @delete
  Future<void> deleteMemoAccountAssociation(
      FloorMemoAccountAssociation memoAccountAssociation);

  @update
  Future<void> updateMemoAccountAssociation(
      FloorMemoAccountAssociation memoAccountAssociation);

  @insert
  Future<void> insertMemoAccountAssociation(
      FloorMemoAccountAssociation memoAccountAssociation);
}
