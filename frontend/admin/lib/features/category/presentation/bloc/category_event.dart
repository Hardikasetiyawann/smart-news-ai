abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class CreateCategoryEvent extends CategoryEvent {
  final String name;
  CreateCategoryEvent(this.name);
}

class UpdateCategoryEvent extends CategoryEvent {
  final int id;
  final String name;
  UpdateCategoryEvent(this.id, this.name);
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;
  DeleteCategoryEvent(this.id);
}
