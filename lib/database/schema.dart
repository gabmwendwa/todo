// Database/schema.dart

// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickeydb/quickeydb.dart';
import 'package:to_do/database/models/category_list.dart';
import 'package:to_do/database/models/task.dart';

class CategoryListSchema extends DataAccessObject<CategoryList> {
  CategoryListSchema()
      : super(
          '''
          CREATE TABLE category_list (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
          ''',
          relations: [
            const HasMany<TaskSchema>(),
          ],
          converter: Converter(
            encode: (categoryList) => CategoryList.fromMap(categoryList),
            decode: (categoryList) => categoryList!.toMap(),
            decodeTable: (categoryList) => categoryList!.toTableMap(),
          ),
        );

  Future<List<CategoryList>> readAllCategories() async {
    // Use your custom query
    List<Map<String, dynamic>> maps = await database!.query('category_list');
    return List.generate(maps.length, (index) {
      return CategoryList.fromMap(maps[index]);
    });
  }

  Future createCategory(Map<String, dynamic> row) async {
    await database!.insert('category_list', row);
  }

  Future updateCategory(Map<String, dynamic> row, int? id) async {
    try {
      await database!.update(
        'category_list',
        row,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }

  Future<void> deleteCategory(int? id) async {
    await database!.delete(
      'category_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class TaskSchema extends DataAccessObject<Task> {
  TaskSchema()
      : super(
          '''
          CREATE TABLE task_manager (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            category_list_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            notes TEXT,
            status TEXT,
            level INTEGER DEFAULT "1" NOT NULL,
            time TEXT NULL,
            date TEXT NULL,
            timestamp TEXT NOT NULL,
            FOREIGN KEY (category_list_id) REFERENCES category_list (id)
          )
          ''',
          relations: [
            const BelongsTo<CategoryListSchema>(),
          ],
          converter: Converter(
            encode: (task) => Task.fromMap(task),
            decode: (task) => task!.toMap(),
            decodeTable: (task) => task!.toTableMap(),
          ),
        );

  // final ValueNotifier<bool> _tasksUpdatedNotifier = ValueNotifier(false);

  // void notifyTaskUpdated() {
  //   _tasksUpdatedNotifier.value = !_tasksUpdatedNotifier.value;
  // }

  // ValueNotifier<bool> get tasksUpdatedNotifier => _tasksUpdatedNotifier;

  Future<List<Task>> taskSearch(String? q) async {
    List<Map<String, dynamic>> maps = await database!.query(
      'task_manager',
      where: 'title LIKE ? OR notes LIKE ?',
      whereArgs: ['%$q%', '%$q%'],
    );

    return List.generate(maps.length, (index) {
      return Task.fromMap(maps[index]);
    });
  }

  Future<int> getTaskTableColumnCount() async {
    final result = await database!.rawQuery('PRAGMA table_info(task_manager);');
    return result.length;
  }

  Future<int> getTaskTableRowCount() async {
    final result =
        await database!.rawQuery('SELECT COUNT(*) FROM task_manager;');
    return result.first['COUNT(*)'] as int;
  }

  Future<List<Task>> readAllTasks() async {
    // Use your custom query
    List<Map<String, dynamic>> maps = await database!.query('task_manager');
    return List.generate(maps.length, (index) {
      return Task.fromMap(maps[index]);
    });
  }

  Future<List<Task>> readAllCategoryTasks(int? id) async {
    // Use your custom query
    List<Map<String, dynamic>> maps = await database!.query(
      'task_manager',
      where: 'category_list_id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (index) {
      return Task.fromMap(maps[index]);
    });
  }

  Future createTask(Map<String, dynamic> row) async {
    await database!.insert('task_manager', row);

    // notifyTaskUpdated();
  }

  Future updateTask(Map<String, dynamic> row, int? id) async {
    await database!.update(
      'task_manager',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );

    // notifyTaskUpdated();
  }

  Future<void> deleteTask(int? id, bool categoryList) async {
    if (categoryList) {
      await database!.delete(
        'task_manager',
        where: 'category_list_id = ?',
        whereArgs: [id],
      );
    } else {
      await database!.delete(
        'task_manager',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    // noti÷fyTaskUpdated();
  }
}
