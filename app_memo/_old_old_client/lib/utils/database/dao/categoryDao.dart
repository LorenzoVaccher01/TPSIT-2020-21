import 'package:floor/floor.dart';
import '../models/category.dart';

@dao
abstract class CategoryDao {
  /*@Query('SELECT * FROM Category')
  Future<List<MemoCategory>> findAllCategory();*/

  @delete
  Future<void> deleteCategory(MemoCategory category);

  @update
  Future<void> updateCategory(MemoCategory category);

  @insert
  Future<void> insertCategory(MemoCategory category);
}
