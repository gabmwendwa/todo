import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quickalert/quickalert.dart';
import 'package:to_do/bloc_task_search/tasks_search_bloc.dart';
import 'package:to_do/components/my_text_form_field.dart';
import 'package:to_do/core/constants.dart';
import 'package:to_do/database/models/task.dart';
import 'package:to_do/database/schema.dart';
import 'package:to_do/widgets/empty.dart';
import 'package:to_do/widgets/list_shimmer.dart';
import 'package:to_do/widgets/task_tile.dart';
import 'package:to_do/widgets/template.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mySearchFocusNode = FocusNode();
  final _mySearchController = TextEditingController();
  final _arrangmentContoller = TextEditingController();
  String arrangeListVal = 'Latest';
  bool _isLoading = false;
  bool _isLoaded = true;

  final TaskSchema _taskSchema = TaskSchema();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

// ----------------------- PRIMARY FUNCTIONS START -----------------------

  Future<void> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(
      const Duration(milliseconds: 1000),
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
    try {
      if (!_isLoading) {
        _isLoading = true;
        getSearchData(_mySearchController.text);

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

  Future<void> getSearchData(String q) async {
    if (q.trim().isNotEmpty) {
      context.read<TasksSearchBloc>().add(ReadTaskSearch(q: q));
    } else {
      Future.delayed(
          const Duration(
            milliseconds: 500,
          ), () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Search is empty!',
          text: 'Please try again.',
          onConfirmBtnTap: () {
            context.read<TasksSearchBloc>().add(
                  ReadTaskEmpty(),
                );

            Navigator.pop(context);
          },
        );
      });
    }
    setState(() {
      _isLoading = false;
      _isLoaded = true;
    });
  }

// ----------------------- PRIMARY FUNCTIONS END -----------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final mybloc = context.read<TasksSearchBloc>();
    context.read<TasksSearchBloc>().add(
          ReadTaskEmpty(),
        );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mySearchController.dispose();
    _mySearchFocusNode.dispose();
  }

// ----------------------- TEST FUNCTIONS START -----------------------

  Future<int> fetchCountData() async {
    int count = await _taskSchema.getTaskTableRowCount();
    return count;
  }

  Future<int> fetchColumnData() async {
    int count = await _taskSchema.getTaskTableColumnCount();
    return count;
  }

  Future<List<Task>> fetchTaskSearch() async {
    return await _taskSchema.taskSearch("");
  }

// ----------------------- TEST FUNCTIONS END -----------------------

// ----------------------- APPBAR START -----------------------

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Search'),
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

// ----------------------- ICON DATA START -----------------------

  IconData _searchIcon() {
    return Platform.isIOS ? CupertinoIcons.search_circle : Icons.search_rounded;
  }

  IconData _listIcon() {
    return Platform.isIOS ? CupertinoIcons.square_list : Icons.list_alt_rounded;
  }
// ----------------------- ICON DATA END -----------------------

// ----------------------- NARROW LAYOUT START -----------------------

  Widget _narrowLayout() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                MyTextFormField(
                  autoFocus: true,
                  focusNode: _mySearchFocusNode,
                  textEditingController: _mySearchController,
                  textLabel: 'Search',
                  obscureText: false,
                  prefixIcon: Platform.isIOS
                      ? CupertinoIcons.search_circle
                      : Icons.search_rounded,
                  what: 'search',
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.none,
                  onSubmit: (value) {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(
                        Duration(
                          seconds: value.trim().isNotEmpty ? 3 : 0,
                        ), () {
                      getSearchData(_mySearchController.text);
                    });
                  },
                  readOnly: false,
                ),
                if (_isLoading) ...[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .75,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: SmartRefresher(
                    enablePullUp: false,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: (!_isLoaded)
                        ? const ListShimmer(
                            height: 200.0,
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<TasksSearchBloc, TasksSearchState>(
                                  builder: (context, state) {
                                    if (state is TasksSearchListUpdate &&
                                        state.tasks.isNotEmpty) {
                                      final tasks = state.tasks;

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Priority
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                  bottom: 10,
                                                ),
                                                child: DropdownMenu<String>(
                                                  initialSelection:
                                                      arrangeList.first,
                                                  controller:
                                                      _arrangmentContoller,
                                                  onSelected: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      arrangeListVal = value!;
                                                    });
                                                  },
                                                  dropdownMenuEntries: [
                                                    'Latest',
                                                    'Oldest'
                                                  ].map<
                                                          DropdownMenuEntry<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuEntry<
                                                        String>(
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
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              reverse:
                                                  arrangeListVal == 'Latest'
                                                      ? true
                                                      : false,
                                              shrinkWrap: true,
                                              itemCount: tasks.length,
                                              itemBuilder: (context, index) {
                                                Task tasklist = tasks[index];
                                                return TaskTile(
                                                  label: '',
                                                  tasklist: tasklist,
                                                  searchString:
                                                      _mySearchController.text,
                                                );
                                              },
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Priority
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                  bottom: 20,
                                                ),
                                                child: DropdownMenu<String>(
                                                  initialSelection:
                                                      arrangeList.first,
                                                  controller:
                                                      _arrangmentContoller,
                                                  onSelected: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      arrangeListVal = value!;
                                                    });
                                                  },
                                                  dropdownMenuEntries: [
                                                    'Latest',
                                                    'Oldest'
                                                  ].map<
                                                          DropdownMenuEntry<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuEntry<
                                                        String>(
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
                                        message:
                                            _mySearchController.text.isEmpty
                                                ? 'Begin Search'
                                                : _isLoading
                                                    ? 'Searching...'
                                                    : 'No Results',
                                        icon:
                                            _mySearchController.text.isEmpty ||
                                                    _isLoading
                                                ? _searchIcon()
                                                : _listIcon(),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ----------------------- NARROW LAYOUT END -----------------------

  @override
  Widget build(BuildContext context) {
    return MyTemplate(
        appBar: _appBar(),
        wideLayout: _wideLayout(),
        narrowLayout: _narrowLayout());
  }
}
