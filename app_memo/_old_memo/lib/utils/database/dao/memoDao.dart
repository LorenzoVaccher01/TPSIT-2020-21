import 'package:floor/floor.dart';
import '../models/memo.dart';

@dao
abstract class MemoDao {
  @Query('SELECT * FROM Memo')
  Future<List<FloorMemo>> findAllMemo();

  @Query('SELECT * FROM Memo WHERE id = :id')
  Future<FloorMemo> findMemoById(int id);

  @Query('SELECT * FROM Memo WHERE title = :title')
  Future<FloorMemo> findMemoByTitle(String title);

  @Query('SELECT * FROM Memo WHERE categoryId = :categoryId')
  Future<FloorMemo> findMemoByCategoryId(int categoryId);

  @delete
  Future<void> deleteMemo(FloorMemo memo);

  @update
  Future<void> updateMemo(FloorMemo memo);

  @insert
  Future<void> insertMemo(FloorMemo memo);
}