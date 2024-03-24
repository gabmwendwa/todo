import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickeydb/quickeydb.dart';
import 'package:to_do/bloc_category/categories_bloc.dart';
import 'package:to_do/bloc_task_search/tasks_search_bloc.dart';
import 'package:to_do/bloc_tasks/tasks_bloc.dart';
import 'package:to_do/core/constants.dart';
import 'package:to_do/database/schema.dart';
import 'package:to_do/screen/category_screen.dart';
import 'package:to_do/screen/index.dart';
import 'package:to_do/screen/search_screen.dart';
import 'package:to_do/screen/splashscreen.dart';
import 'package:to_do/screen/task_screen.dart';
import 'package:to_do/styles/dark_theme.dart';
import 'package:to_do/styles/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDB();
  runApp(MyApp());
}

Future<void> initializeDB() async {
  await QuickeyDB.initialize(
    dbName: "todo_v1",
    persist: false,
    dbVersion: 1,
    dataAccessObjects: [
      TaskSchema(),
      CategoryListSchema(),
    ],
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });
  final CategoryListSchema categoryListSchema = CategoryListSchema();
  final TaskSchema taskSchema = TaskSchema();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesBloc(
            categoryListSchema: categoryListSchema,
          ),
        ),
        BlocProvider(
          create: (context) => TasksBloc(taskSchema: taskSchema),
        ),
        BlocProvider(
          create: (context) => TasksSearchBloc(taskSchema: taskSchema),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: mainAppName,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const SplashScreen(),
        routes: {
          SplashScreen.routeName: (ctx) => const SplashScreen(),
          IndexScreen.routeName: (ctx) => const IndexScreen(),
          CategoryScreen.routeName: (ctx) => const CategoryScreen(),
          TaskScreen.routeName: (ctx) => const TaskScreen(
                flag: '',
                label: '',
              ),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
        },
      ),
    );
  }
}
