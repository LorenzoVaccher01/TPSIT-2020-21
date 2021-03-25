import 'package:floor/floor.dart';
import '../models/tag.dart';

@dao
abstract class TagDao {
  @Query('SELECT * FROM FloorTag')
  Future<List<FloorTag>> findAllTag();

  @Query('SELECT * FROM FloorTag WHERE id=(SELECT max(id) FROM FloorTag)')
  Future<FloorTag> findLastTag();

  @Query('SELECT * FROM FloorTag WHERE id = :id')
  Future<FloorTag> findTagById(int id);

  @Query('SELECT * FROM FloorTag WHERE accountId = :accountId')
  Future<FloorTag> findTagByAccountId(int accountId);

  @Query('SELECT * FROM FloorTag WHERE name = :name')
  Future<FloorTag> findTagByName(String name);

  @Query('DELETE FROM FloorTag WHERE id = :id')
  Future<FloorTag> deleteTagById(int id);

  @delete
  Future<void> deleteTag(FloorTag tag);

  @update
  Future<void> updateTag(FloorTag tag);

  @insert
  Future<void> insertTag(FloorTag tag);
}
