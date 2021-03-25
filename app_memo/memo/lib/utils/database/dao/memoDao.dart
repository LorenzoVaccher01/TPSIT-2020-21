import 'package:floor/floor.dart';
import '../models/memo.dart';

@dao
abstract class MemoDao {
  @Query('SELECT * FROM FloorMemo')
  Future<List<FloorMemo>> findAllMemo();

  @Query('SELECT * FROM FloorMemo WHERE id=(SELECT max(id) FROM FloorMemo)')
  Future<FloorMemo> findLastMemo();

  @Query('SELECT * FROM FloorMemo WHERE id = :id')
  Future<FloorMemo> findMemoById(int id);

  @Query('SELECT * FROM FloorMemo WHERE title = :title')
  Future<FloorMemo> findMemoByTitle(String title);

  @Query('SELECT * FROM FloorMemo WHERE categoryId = :categoryId')
  Future<FloorMemo> findMemoByCategoryId(int categoryId);

  @Query('DELETE FROM FloorMemo WHERE id = :id')
  Future<FloorMemo> deleteMemoById(int id);

  @delete
  Future<void> deleteMemo(FloorMemo memo);

  @update
  Future<void> updateMemo(FloorMemo memo);

  @insert
  Future<void> insertMemo(FloorMemo memo);
}