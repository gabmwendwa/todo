// Import both event and state files
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/database/models/category_list.dart';
import 'package:to_do/database/schema.dart';

part 'categories_events.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvents, CategoriesState> {
  final CategoryListSchema categoryListSchema;
  CategoriesBloc({
    required this.categoryListSchema,
  }) : super(CategoriesListInitial(categorylist: [])) {
    //functions here
    on<ReadCategories>(_onReadCategories);
    on<AddCategory>(_addCategory);
    on<UpdateCategory>(_updateCategory);
    on<DeleteCategory>(_deleteCategory);
  }

  void _onReadCategories(
      ReadCategories event, Emitter<CategoriesState> emit) async {
    try {
      final categories = await categoryListSchema.readAllCategories();

      emit(CategoriesListUpdate(categorylist: categories));
      debugPrint(
          "------------------> Category List Bloc: ${state.categorylist}");
    } catch (e) {
      // Handle errors here
      debugPrint("------------------> Exception: $e");
    }
  }

  //Create
  void _addCategory(AddCategory event, Emitter<CategoriesState> emit) async {
    debugPrint("------------------> Create data: ${event.row}");
    try {
      await categoryListSchema.createCategory(event.row);

      debugPrint(
          "------------------> Category List Bloc Create: ${state.categorylist}");
    } catch (e) {
      debugPrint("Error updating category: $e");
    }
  }

  //Update
  void _updateCategory(
      UpdateCategory event, Emitter<CategoriesState> emit) async {
    try {
      for (int i = 0; i < state.categorylist.length; i++) {
        if (event.categorylist.id == state.categorylist[i].id) {
          state.categorylist[i] = event.categorylist;
        }
      }
      emit(
        CategoriesListUpdate(categorylist: state.categorylist),
      );
      debugPrint(
          "------------------> Category List Bloc Delete: ${state.categorylist}");
    } catch (e) {
      debugPrint("Error updating category: $e");
    }
  }

  //Delete
  Future<void> _deleteCategory(
      DeleteCategory event, Emitter<CategoriesState> emit) async {
    try {
      final TaskSchema taskSchema = TaskSchema();
      await categoryListSchema.deleteCategory(event.categorylist.id);
      await taskSchema.deleteTask(event.categorylist.id, true);
      state.categorylist.remove(event.categorylist);
      emit(CategoriesListUpdate(categorylist: state.categorylist));

      debugPrint(
          "------------------> Category List Bloc Delete: ${state.categorylist}");
    } catch (e) {
      debugPrint("Error deleting category: $e");
    }
  }
}
