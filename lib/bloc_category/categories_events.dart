// Export for bloc file
part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvents {}

// Create
class AddCategory extends CategoriesEvents {
  final CategoryList categorylist;
  final Map<String, dynamic> row;

  AddCategory({
    required this.categorylist,
    required this.row,
  });
}

class ReadCategories extends CategoriesEvents {}

// Update
class UpdateCategory extends CategoriesEvents {
  final CategoryList categorylist;
  final Map<String, dynamic> row;

  UpdateCategory({
    required this.categorylist,
    required this.row,
  });
}

// Delete
class DeleteCategory extends CategoriesEvents {
  final CategoryList categorylist;

  DeleteCategory({
    required this.categorylist,
  });
}
