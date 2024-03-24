// Export for bloc file
part of 'tasks_search_bloc.dart';

@immutable
abstract class TasksSearchEvents {}

// Read
class ReadTaskEmpty extends TasksSearchEvents {}

class ReadTaskSearch extends TasksSearchEvents {
  final String q;
  ReadTaskSearch({
    required this.q,
  });
}
