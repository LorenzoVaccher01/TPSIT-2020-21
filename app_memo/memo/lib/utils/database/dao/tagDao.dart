import 'package:floor/floor.dart';
import '../models/tag.dart';

@dao
abstract class TagDao {
  @Query('SELECT * FROM Tag')
  Future<List<FloorTag>> findAllTag();

  @Query('SELECT * FROM Tag WHERE id = :id')
  Future<FloorTag> findTagById(int id);

  @Query('SELECT * FROM Tag WHERE accountId = :accountId')
  Future<FloorTag> findTagByAccountId(int accountId);

  @Query('SELECT * FROM Tag WHERE name = :name')
  Future<FloorTag> findTagByName(String name);

  @delete
  Future<void> deleteTag(FloorTag tag);

  @update
  Future<void> updateTag(FloorTag tag);

  @insert
  Future<void> insertTag(FloorTag tag);
}
