import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll();
  Future<void> create(String name);
  Future<void> update(int id, String name);
  Future<void> delete(int id);
}
