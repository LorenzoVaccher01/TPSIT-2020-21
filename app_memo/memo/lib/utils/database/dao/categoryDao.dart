import 'package:floor/floor.dart';
import '../models/category.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM Category')
  Future<List<FloorCategory>> findAllCategory();

  @Query('SELECT * FROM Category WHERE id = :id')
  Future<List<FloorCategory>> findAllCategoryById(int id);

  @Query('SELECT * FROM Category WHERE email = :email')
  Future<List<FloorCategory>> findAllCategoryByEmail(String email);

  @delete
  Future<void> deleteCategory(FloorCategory category);

  @update
  Future<void> updateCategory(FloorCategory category);

  @insert
  Future<void> insertCategory(FloorCategory category);
}
