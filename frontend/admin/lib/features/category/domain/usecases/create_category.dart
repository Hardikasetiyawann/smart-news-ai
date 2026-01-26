import '../repositories/category_repository.dart';

class CreateCategory {
  final CategoryRepository repo;
  CreateCategory(this.repo);

  Future execute(String name) => repo.create(name);
}
