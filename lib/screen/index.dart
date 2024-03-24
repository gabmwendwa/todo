import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/bloc_category/categories_bloc.dart';
import 'package:to_do/core/constants.dart';
import 'package:to_do/database/models/category_list.dart';
import 'package:to_do/screen/category_screen.dart';
import 'package:to_do/screen/search_screen.dart';
import 'package:to_do/widgets/category_form.dart';
import 'package:to_do/widgets/empty.dart';
import 'package:to_do/widgets/list_shimmer.dart';
import 'package:to_do/widgets/template.dart';

class IndexScreen extends StatefulWidget {
  static const routeName = '/index';

  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _arrangmentContoller = TextEditingController();

  int _selectedIndex = 0;
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

  Future<void> loadData() async {
    try {
      if (!_isLoading) {
        _isLoading = true;
        context.read<CategoriesBloc>().add(ReadCategories());

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

  _firstTimeMessage() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'First Time Message',
        text: 'You can pull to refresh the page.',
        barrierDismissible: false,
        onConfirmBtnTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(
            'isFirstTime',
            false,
          );

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        });
  }

  Future<void> _isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('isFirstTime') ?? true;
    if (firstTime) {
      _firstTimeMessage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Then close the drawer
    Navigator.pop(context);

    Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      try {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          text:
              'Navigate to \'${drawerList[_selectedIndex]['label']}\' screen.',
        );
      } catch (e) {
        debugPrint('Exception: $e');
      }
    });
  }

// ----------------------- PRIMARY FUNCTIONS END -----------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      loadData();
    });
    Future.delayed(const Duration(seconds: 4), () {
      _isFirstTime();
    });
  }

// ----------------------- APPBAR START -----------------------

  PreferredSizeWidget _appBar(context) {
    return AppBar(
      title: Text(mainAppName),
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

// ----------------------- DRAWER START -----------------------

  Widget _drawer(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          children: [
            SizedBox(
              height: 320,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(70),
                          child: Image.asset(
                            profilePlaceholder,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        companyName,
                        style: TextStyle(
                          fontFamily: appSubTitleFont,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              height: double.maxFinite,
              child: ListView.separated(
                itemCount: drawerList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: drawerList[i]['icon'],
                    title: Text(
                      '${drawerList[i]['label']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: _selectedIndex == i,
                    selectedColor: Colors.white,
                    selectedTileColor: Theme.of(context).primaryColorLight,
                    iconColor: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorDark,
                    onTap: () {
                      // Update the state of the app
                      _onItemTapped(i);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
            const Divider(),
            Text(
              copyrightText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

// ----------------------- DRAWER END -----------------------

// ----------------------- WIDE LAYOUT START -----------------------

  Widget _wideLayout(context) {
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
                height: 150.0,
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CategoriesBloc, CategoriesState>(
                      builder: (context, state) {
                        if (state is CategoriesListUpdate &&
                            state.categorylist.isNotEmpty) {
                          final categories = state.categorylist;

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
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    CategoryList categorylist =
                                        categories[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 5,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              CategoryScreen.routeName,
                                              arguments: {
                                                'category_id':
                                                    categorylist.id.toString(),
                                                'categoryLabel':
                                                    categorylist.title,
                                              });
                                        },
                                        child: Card(
                                          child: ListTile(
                                            title: Text(
                                              categorylist.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Divider(),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        // edit category
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                CategoryScreen
                                                                    .routeName,
                                                                arguments: {
                                                              'category_id':
                                                                  categorylist
                                                                      .id
                                                                      .toString(),
                                                              'categoryLabel':
                                                                  categorylist
                                                                      .title,
                                                            });
                                                      },
                                                      icon: Icon(
                                                        Platform.isIOS
                                                            ? CupertinoIcons.eye
                                                            : Icons
                                                                .visibility_rounded,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () {
                                                        // edit category
                                                        _categoryForm(
                                                            context,
                                                            'Edit Category',
                                                            categorylist.title
                                                                .toString(),
                                                            'edit',
                                                            categorylist.id);
                                                      },
                                                      icon: Icon(
                                                        Platform.isIOS
                                                            ? CupertinoIcons
                                                                .pencil_circle
                                                            : Icons
                                                                .edit_rounded,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () {
                                                        // delete category
                                                        QuickAlert.show(
                                                          context: context,
                                                          type: QuickAlertType
                                                              .confirm,
                                                          title:
                                                              'Are you sure?',
                                                          text:
                                                              '\'${categorylist.title}\' information will be lost forever.',
                                                          confirmBtnText: 'Yes',
                                                          cancelBtnText: 'No',
                                                          onCancelBtnTap: () =>
                                                              {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                          },
                                                          onConfirmBtnTap: () =>
                                                              {
                                                            context
                                                                .read<
                                                                    CategoriesBloc>()
                                                                .add(
                                                                  DeleteCategory(
                                                                      categorylist:
                                                                          categorylist),
                                                                ),
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Platform.isIOS
                                                            ? CupertinoIcons
                                                                .delete
                                                            : Icons
                                                                .delete_rounded,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      humanReadableDateTime(
                                                          categorylist
                                                              .timestamp),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
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
                            message: 'No Categories',
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

  Widget _floatingButton(context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 10,
      onPressed: () {
        _categoryForm(
          context,
          'Create New Category',
          '',
          'create',
          0,
        );
      },
      child: Icon(
        Platform.isIOS ? CupertinoIcons.add : Icons.add_rounded,
        size: 40,
      ),
    );
  }

// ----------------------- FLOATING BUTTON END -----------------------

// ----------------------- CATEGORY FORM START -----------------------

  void _categoryForm(
      context, String label, String? title, String? flag, int? id) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                leading: IconButton(
                  icon: Icon(
                    Platform.isIOS
                        ? CupertinoIcons.pencil_circle
                        : Icons.edit_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                actions: [
                  if (flag! == 'edit') ...[
                    IconButton(
                      icon: Icon(
                        Platform.isIOS
                            ? CupertinoIcons.clear_circled
                            : Icons.close_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CategoryForm(
                  title: title,
                  flag: flag,
                  id: id,
                ),
              ),
            ),
          );
        });
  }

// ----------------------- CATEGORY FORM END -----------------------

  @override
  Widget build(BuildContext context) {
    return MyTemplate(
      appBar: _appBar(context),
      drawer: _drawer(context),
      wideLayout: _wideLayout(context),
      narrowLayout: _narrowLayout(),
      floatingButton: _floatingButton(context),
    );
  }
}
