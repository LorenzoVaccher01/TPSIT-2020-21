import 'package:floor/floor.dart';
import '../models/tag.dart';

@dao
abstract class TagDao {
  /*@Query('SELECT * FROM Tag')
  Future<List<MemoTag>> findAllTag();*/

  /*@Query('SELECT * FROM Tag WHERE id = :id')
  Future<Tag> findTagById(int id);*/

  @delete
  Future<void> deleteTag(MemoTag tag);

  @update
  Future<void> updateTag(MemoTag tag);

  @insert
  Future<void> insertTag(MemoTag tag);
}
