import 'package:floor/floor.dart';
import '../models/memoTagAssociation.dart';

@dao
abstract class MemoTagAssociationDao {
  @delete
  Future<void> deleteMemoAccountAssociation(
      MemoTagAssociation memoTagAssociation);

  @update
  Future<void> updateMemoAccountAssociation(
      MemoTagAssociation memoTagAssociation);

  @insert
  Future<void> insertMemoAccountAssociation(
      MemoTagAssociation memoTagAssociation);
}
