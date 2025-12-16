// ignore_for_file: prefer_null_aware_operators

import 'package:to_do/database/models/category_list.dart';

class Task {
  int? id;
  int? category_list_id;
  String title;
  String notes;
  String status;
  int level;
  String? time;
  String? date;
  String timestamp;
  CategoryList? categoryList;

  Task({
    this.id,
    this.category_list_id,
    required this.title,
    required this.notes,
    required this.status,
    required this.level,
    this.time,
    this.date,
    required this.timestamp,
    this.categoryList,
  });

  Task.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        category_list_id = map['category_list_id'],
        title = map['title'],
        notes = map['notes'],
        status = map['status'],
        level = map['level'],
        time = map['time'],
        date = map['date'],
        timestamp = map['timestamp'],
        categoryList = map['categoryList'] != null
            ? CategoryList.fromMap(map['categoryList'])
            : null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'category_list_id': category_list_id,
        'title': title,
        'notes': notes,
        'status': status,
        'level': level,
        'time': time,
        'date': date,
        'timestamp': timestamp,
        'category': categoryList != null ? categoryList?.toMap() : null,
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'category_list_id': category_list_id,
        'title': title,
        'notes': notes,
        'status': status,
        'level': level,
        'time': time,
        'date': date,
        'timestamp': timestamp,
      };
}
