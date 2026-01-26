import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/delete_category.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategories>((e, emit) async {
      emit(CategoryLoading());
      try {
        final data = await getCategories.execute();
        emit(CategoryLoaded(data));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<CreateCategoryEvent>((e, emit) async {
      await createCategory.execute(e.name);
      add(LoadCategories());
    });

    on<UpdateCategoryEvent>((e, emit) async {
      await updateCategory.execute(e.id, e.name);
      add(LoadCategories());
    });

    on<DeleteCategoryEvent>((e, emit) async {
      try {
        await deleteCategory.execute(e.id);
        add(LoadCategories());
      } catch (err) {
        emit(CategoryError(err.toString()));
      }
    });
  }
}
