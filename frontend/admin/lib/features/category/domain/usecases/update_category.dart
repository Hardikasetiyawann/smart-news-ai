import '../repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repo;
  UpdateCategory(this.repo);

  Future execute(int id, String name) => repo.update(id, name);
}
