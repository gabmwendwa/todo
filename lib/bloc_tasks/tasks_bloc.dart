// Import both event and state files
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/database/models/task.dart';
import 'package:to_do/database/schema.dart';

part 'tasks_events.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvents, TasksState> {
  final TaskSchema taskSchema;
  TasksBloc({
    required this.taskSchema,
  }) : super(TasksListInitial(tasks: [])) {
    //functions here
    on<ReadTask>(_onReadTasks);
    on<AddTask>(_addTasks);
    on<UpdateTask>(_updateTasks);
    on<DeleteTask>(_deleteTasks);
  }

  //Create
  Future<void> _addTasks(AddTask event, Emitter<TasksState> emit) async {
    debugPrint("------------------> Create data: ${event.row}");
    try {
      await taskSchema.createTask(event.row);

      debugPrint("------------------> Task List Bloc Create: ${state.tasks}");
    } catch (e) {
      debugPrint("Error updating category: $e");
    }
  }

  // Read
  Future<void> _onReadTasks(ReadTask event, Emitter<TasksState> emit) async {
    try {
      final tasks = await taskSchema.readAllCategoryTasks(event.categoryid);

      emit(TaskListUpdate(tasks: tasks));
      debugPrint("------------------> Task List Bloc: ${state.tasks}");
    } catch (e) {
      // Handle errors here
      debugPrint("------------------> Exception: $e");
    }
  }

  //Update
  Future<void> _updateTasks(UpdateTask event, Emitter<TasksState> emit) async {
    try {
      for (int i = 0; i < state.tasks.length; i++) {
        if (event.tasks.id == state.tasks[i].id) {
          state.tasks[i] = event.tasks;
        }
      }
      emit(
        TaskListUpdate(tasks: state.tasks),
      );
      debugPrint("------------------> Task List Bloc Delete: ${state.tasks}");
    } catch (e) {
      debugPrint("Error updating category: $e");
    }
  }

  //Delete
  Future<void> _deleteTasks(DeleteTask event, Emitter<TasksState> emit) async {
    try {
      // await categoryListSchema.deleteCategory(event.categorylist.id);
      await taskSchema.deleteTask(
        event.tasks.id,
        false,
      );
      state.tasks.remove(event.tasks);
      emit(TaskListUpdate(tasks: state.tasks));

      debugPrint("------------------> Task List Bloc Delete: ${state.tasks}");
    } catch (e) {
      debugPrint("Error deleting category: $e");
    }
  }
}
