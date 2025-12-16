// Export for bloc file
part of 'tasks_search_bloc.dart';

abstract class TasksSearchState {
  List<Task> tasks;

  TasksSearchState({
    required this.tasks,
  });
}

//Initial List
class TasksListInitial extends TasksSearchState {
  TasksListInitial({
    required List<Task> tasks,
  }) : super(
          tasks: tasks,
        );
}

//Update List
class TasksSearchListUpdate extends TasksSearchState {
  TasksSearchListUpdate({
    required List<Task> tasks,
  }) : super(
          tasks: tasks,
        );
}
