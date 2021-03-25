import 'package:floor/floor.dart';
import '../models/memoAccountAssociation.dart';

@dao
abstract class MemoAccountAssociationDao {
  @delete
  Future<void> deleteMemoAccountAssociation(MemoAccountAssociation memoAccountAssociation);

  @update
  Future<void> updateMemoAccountAssociation(MemoAccountAssociation memoAccountAssociation);

  @insert
  Future<void> insertMemoAccountAssociation(MemoAccountAssociation memoAccountAssociation);
}
