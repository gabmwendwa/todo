// Export for bloc file
part of 'categories_bloc.dart';

abstract class CategoriesState {
  List<CategoryList> categorylist;

  CategoriesState({
    required this.categorylist,
  });
}

//Initial List
class CategoriesListInitial extends CategoriesState {
  CategoriesListInitial({
    required List<CategoryList> categorylist,
  }) : super(
          categorylist: categorylist,
        );
}

//Update List
class CategoriesListUpdate extends CategoriesState {
  CategoriesListUpdate({
    required List<CategoryList> categorylist,
  }) : super(
          categorylist: categorylist,
        );
}
