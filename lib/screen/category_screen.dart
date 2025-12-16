import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do/bloc_tasks/tasks_bloc.dart';
import 'package:to_do/core/constants.dart';
import 'package:to_do/database/models/task.dart';
import 'package:to_do/screen/search_screen.dart';
import 'package:to_do/screen/task_screen.dart';
import 'package:to_do/widgets/empty.dart';
import 'package:to_do/widgets/list_shimmer.dart';
import 'package:to_do/widgets/task_tile.dart';
import 'package:to_do/widgets/template.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';

  const CategoryScreen({
    super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  _getArguments() {
    return (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
        as Map;
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _arrangmentContoller = TextEditingController();

  bool _isLoading = false;
  bool _isLoaded = false;
  String arrangeListVal = 'Latest';

// ----------------------- PRIMARY FUNCTIONS START -----------------------

  Future<void> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    // if failed,use refreshFailed()
    _isLoading = false;

    loadData();

    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    // monitor network fetch
    await Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
    );
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void loadData() async {
    final mybloc = context.read<TasksBloc>();
    try {
      if (!_isLoading) {
        _isLoading = true;
        mybloc.add(
            ReadTask(categoryid: int.parse(_getArguments()['category_id'])));

        setState(() {
          _isLoaded = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      _disconnect();
      return;
    }
  }

  _disconnect() async {
    if (_isLoading) {
      setState(() {
        _isLoading = false;
        _isLoaded = false;
      });
    }
  }

// ----------------------- PRIMARY FUNCTIONS END -----------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      loadData();
    });
  }

// ----------------------- APPBAR START -----------------------

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        _getArguments()['categoryLabel'],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          icon: Icon(
            Platform.isIOS ? CupertinoIcons.search_circle : Icons.search,
            size: 30,
          ),
        ),
      ],
    );
  }

// ----------------------- APPBAR END -----------------------

// ----------------------- WIDE LAYOUT START -----------------------

  Widget _wideLayout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: myBGGradient,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 3,
            style: BorderStyle.solid,
          )),
          child: _narrowLayout(),
        ),
      ),
    );
  }

// ----------------------- WIDE LAYOUT END -----------------------

// ----------------------- NARROW LAYOUT START -----------------------

  Widget _narrowLayout() {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      color: Theme.of(context).colorScheme.primary,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .8,
      ),
      width: MediaQuery.of(context).size.width,
      child: SmartRefresher(
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: (!_isLoaded)
            ? const ListShimmer(
                height: 250.0,
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<TasksBloc, TasksState>(
                      builder: (context, state) {
                        if (state is TaskListUpdate && state.tasks.isNotEmpty) {
                          final tasks = state.tasks;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Priority
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      bottom: 10,
                                    ),
                                    child: DropdownMenu<String>(
                                      initialSelection: arrangeList.first,
                                      controller: _arrangmentContoller,
                                      onSelected: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          arrangeListVal = value!;
                                        });
                                      },
                                      dropdownMenuEntries: ['Latest', 'Oldest']
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                          value: value,
                                          label: value,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  reverse:
                                      arrangeListVal == 'Latest' ? true : false,
                                  shrinkWrap: true,
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    Task tasklist = tasks[index];
                                    return TaskTile(
                                      tasklist: tasklist,
                                      label: _getArguments()['categoryLabel'],
                                      categoryId:
                                          _getArguments()['category_id'],
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Priority
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 20,
                                      bottom: 20,
                                    ),
                                    child: DropdownMenu<String>(
                                      initialSelection: arrangeList.first,
                                      controller: _arrangmentContoller,
                                      onSelected: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          arrangeListVal = value!;
                                        });
                                      },
                                      dropdownMenuEntries: ['Latest', 'Oldest']
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                          value: value,
                                          label: value,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Empty(
                            message: 'No Tasks',
                            icon: Platform.isIOS
                                ? CupertinoIcons.square_list
                                : Icons.list_alt_rounded,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

// ----------------------- NARROW LAYOUT END -----------------------

// ----------------------- FLOATING BUTTON START -----------------------

  Widget _floatingButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 10,
      onPressed: () {
        // Navigator.of(context).pushNamed(TaskScreen.routeName);
        _taskForm(context, 'Create New Task');
      },
      child: Icon(
        Platform.isIOS ? CupertinoIcons.add : Icons.add_rounded,
        size: 40,
      ),
    );
  }

// ----------------------- FLOATING BUTTON END -----------------------

// ----------------------- CATEGORY FORM START -----------------------

  void _taskForm(context, String label) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext bc) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.87,
            child: TaskScreen(
              flag: 'create',
              label: label,
              categoryId: _getArguments()['category_id'],
            ),
          );
        });
  }

// ----------------------- CATEGORY FORM END -----------------------

  @override
  Widget build(BuildContext context) {
    return MyTemplate(
      appBar: _appBar(),
      wideLayout: _wideLayout(),
      narrowLayout: _narrowLayout(),
      floatingButton: _floatingButton(),
    );
  }
}
