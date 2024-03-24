// Import both event and state files
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/database/models/task.dart';
import 'package:to_do/database/schema.dart';

part 'tasks_search_events.dart';
part 'tasks_search_state.dart';

class TasksSearchBloc extends Bloc<TasksSearchEvents, TasksSearchState> {
  final TaskSchema taskSchema;
  TasksSearchBloc({
    required this.taskSchema,
  }) : super(TasksListInitial(tasks: [])) {
    //functions here
    on<ReadTaskEmpty>(_onReadTasksEmpty);
    on<ReadTaskSearch>(_onReadTaskSearch);
  }

  // Read
  Future<void> _onReadTasksEmpty(
      ReadTaskEmpty event, Emitter<TasksSearchState> emit) async {
    try {
      emit(TasksSearchListUpdate(tasks: []));
      debugPrint("------------------> Task Search List Bloc: ${state.tasks}");
    } catch (e) {
      // Handle errors here
      debugPrint("------------------> Exception: $e");
    }
  }

  Future<void> _onReadTaskSearch(
      ReadTaskSearch event, Emitter<TasksSearchState> emit) async {
    try {
      final tasks = await taskSchema.taskSearch(event.q);

      emit(TasksSearchListUpdate(tasks: tasks));
      debugPrint("------------------> Task Search List Bloc: ${state.tasks}");
    } catch (e) {
      // Handle errors here
      debugPrint("------------------> Exception: $e");
    }
  }
}
