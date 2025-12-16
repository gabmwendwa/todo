import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do/core/constants.dart';
import 'package:to_do/widgets/task_form.dart';
import 'package:to_do/widgets/template.dart';

class TaskScreen extends StatefulWidget {
  static const routeName = '/task';
  final String label;
  final String flag;
  final int? id;
  final String? categoryId;
  final String? title;
  final String? notes;
  final String? status;
  final int? level;
  final String? time;
  final String? date;
  final String? searchString;

  const TaskScreen({
    super.key,
    required this.label,
    required this.flag,
    this.id,
    this.categoryId,
    this.title,
    this.notes,
    this.status,
    this.level,
    this.time,
    this.date,
    this.searchString,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
// ----------------------- APPBAR START -----------------------

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(widget.label),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: widget.flag == 'create'
            ? Icon(
                Platform.isIOS
                    ? CupertinoIcons.clear_circled
                    : Icons.close_rounded,
                size: 30,
              )
            : Icon(
                Platform.isIOS
                    ? CupertinoIcons.back
                    : Icons.chevron_left_rounded,
                size: 30,
              ),
      ),
      actions: [
        if (widget.flag == 'update') ...[
          IconButton(
            icon: Icon(
              Platform.isIOS
                  ? CupertinoIcons.pencil_circle
                  : Icons.edit_rounded,
              size: 30,
            ),
            onPressed: () {},
          ),
        ]
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TaskForm(
        flag: widget.flag,
        categoryId: widget.categoryId ?? '',
        id: widget.id,
        title: widget.title,
        notes: widget.notes,
        status: widget.status,
        level: widget.level,
        time: widget.time,
        date: widget.date,
        searchString: widget.searchString ?? '',
      ),
    );
  }

// ----------------------- NARROW LAYOUT END -----------------------

  @override
  Widget build(BuildContext context) {
    return MyTemplate(
      appBar: _appBar(),
      wideLayout: _wideLayout(),
      narrowLayout: _narrowLayout(),
    );
  }
}
