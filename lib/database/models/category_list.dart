// ignore_for_file: prefer_null_aware_operators

import 'package:to_do/database/models/task.dart';

class CategoryList {
  int? id;
  String title;
  String timestamp;
  Task? task;

  CategoryList({
    this.id,
    required this.title,
    required this.timestamp,
    this.task,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'timestamp': timestamp,
        'task': task != null ? task!.toMap() : null,
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'title': title,
        'timestamp': timestamp,
      };

  CategoryList.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        timestamp = map['timestamp'],
        task = map['task'] != null ? Task.fromMap(map['task']) : null;
}
