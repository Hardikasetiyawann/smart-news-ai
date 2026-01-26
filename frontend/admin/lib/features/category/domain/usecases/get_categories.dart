import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repo;
  GetCategories(this.repo);

  Future execute() => repo.getAll();
}
