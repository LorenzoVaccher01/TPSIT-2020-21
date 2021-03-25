import 'package:floor/floor.dart';
import '../models/category.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM FloorCategory')
  Future<List<FloorCategory>> findAllCategory();

  @Query('SELECT * FROM FloorCategory WHERE id=(SELECT max(id) FROM FloorCategory)')
  Future<FloorCategory> findLastCategory();

  @Query('SELECT * FROM FloorCategory WHERE id = :id')
  Future<List<FloorCategory>> findAllCategoryById(int id);

  @Query('SELECT * FROM FloorCategory WHERE email = :email')
  Future<List<FloorCategory>> findAllCategoryByEmail(String email);

  @Query('DELETE FROM FloorCategory WHERE id = :id')
  Future<FloorCategory> deleteCategoryById(int id);

  @delete
  Future<void> deleteCategory(FloorCategory category);

  @update
  Future<void> updateCategory(FloorCategory category);

  @insert
  Future<void> insertCategory(FloorCategory category);
}
