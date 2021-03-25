import 'package:floor/floor.dart';
import '../models/memo.dart';

@dao
abstract class MemoDao {
  /*@Query('SELECT * FROM Memo')
  Future<List<Memo>> findAllMemo();*/

  /*@Query('SELECT * FROM Memo WHERE id = :id')
  Future<Memo> findMemoById(int id);

  @Query('SELECT * FROM Memo WHERE _memoId = :id')
  Future<Memo> findMemoByIdMemo(int id);*/

  @delete
  Future<void> deleteMemo(Memo memo);

  @update
  Future<void> updateMemo(Memo memo);

  @insert
  Future<void> insertMemo(Memo memo);
}