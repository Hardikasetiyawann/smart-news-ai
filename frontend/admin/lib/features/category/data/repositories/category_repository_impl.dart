import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;
  CategoryRepositoryImpl(this.remote);

  @override
  Future<List<Category>> getAll() => remote.getAll();

  @override
  Future<void> create(String name) => remote.create(name);

  @override
  Future<void> update(int id, String name) => remote.update(id, name);

  @override
  Future<void> delete(int id) => remote.delete(id);
}
