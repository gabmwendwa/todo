// Export for bloc file
part of 'tasks_bloc.dart';

@immutable
abstract class TasksEvents {}

// Create
class AddTask extends TasksEvents {
  final Task tasks;
  final Map<String, dynamic> row;

  AddTask({
    required this.tasks,
    required this.row,
  });
}

// Read
class ReadTask extends TasksEvents {
  final int categoryid;
  ReadTask({
    required this.categoryid,
  });
}

// Update
class UpdateTask extends TasksEvents {
  final Task tasks;
  final Map<String, dynamic> row;

  UpdateTask({
    required this.tasks,
    required this.row,
  });
}

// Delete
class DeleteTask extends TasksEvents {
  final Task tasks;

  DeleteTask({
    required this.tasks,
  });
}
