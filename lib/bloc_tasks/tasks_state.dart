// Export for bloc file
part of 'tasks_bloc.dart';

abstract class TasksState {
  List<Task> tasks;

  TasksState({
    required this.tasks,
  });
}

//Initial List
class TasksListInitial extends TasksState {
  TasksListInitial({
    required List<Task> tasks,
  }) : super(
          tasks: tasks,
        );
}

//Update List
class TaskListUpdate extends TasksState {
  TaskListUpdate({
    required List<Task> tasks,
  }) : super(
          tasks: tasks,
        );
}
