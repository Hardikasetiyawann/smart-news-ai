import '../repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repo;
  DeleteCategory(this.repo);

  Future execute(int id) => repo.delete(id);
}
