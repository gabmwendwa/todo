import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:readmore/readmore.dart';
import 'package:to_do/bloc_task_search/tasks_search_bloc.dart';
import 'package:to_do/core/constants.dart';
import 'package:to_do/database/models/task.dart';
import 'package:to_do/screen/task_screen.dart';

import '../bloc_tasks/tasks_bloc.dart';

class TaskTile extends StatefulWidget {
  final Task tasklist;
  final String label;
  final String? categoryId;
  final String? searchString;
  const TaskTile({
    super.key,
    required this.tasklist,
    required this.label,
    this.categoryId,
    this.searchString,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskScreen(
                flag: 'view',
                label: widget.label,
                id: widget.tasklist.id,
                title: widget.tasklist.title,
                notes: widget.tasklist.notes,
                status: widget.tasklist.status,
                level: widget.tasklist.level,
                time: widget.tasklist.time,
                date: widget.tasklist.date,
              ),
            ),
          );
        },
        child: Card(
          child: ListTile(
            title: Text(
              widget.tasklist.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              children: [
                const Divider(),
                ReadMoreText(
                  widget.tasklist.notes.trim(),
                  trimLines: 2,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                  colorClickableText: Theme.of(context).primaryColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show More',
                  trimExpandedText: ' Hide ',
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "Priority:\t\t\t",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      priorityLabelList[widget.tasklist.level - 1],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "Status:\t\t\t",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.tasklist.status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                if ((widget.tasklist.time!.trim() != '' &&
                        widget.tasklist.time != null) ||
                    (widget.tasklist.date!.trim() != '' &&
                        widget.tasklist.date != null)) ...[
                  Row(
                    children: [
                      if (widget.tasklist.time!.trim() != '' &&
                          widget.tasklist.time != null) ...[
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Time:\t\t\t",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${widget.tasklist.time}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                      if (widget.tasklist.date!.trim() != '' &&
                          widget.tasklist.date != null) ...[
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Date:\t\t\t",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${widget.tasklist.date}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                  const Divider(),
                ],
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        debugPrint(
                            '--------->Task List Data: ${widget.tasklist}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskScreen(
                              flag: 'view',
                              label: widget.label,
                              id: widget.tasklist.id,
                              title: widget.tasklist.title,
                              notes: widget.tasklist.notes,
                              status: widget.tasklist.status,
                              level: widget.tasklist.level,
                              time: widget.tasklist.time,
                              date: widget.tasklist.date,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Platform.isIOS
                            ? CupertinoIcons.eye
                            : Icons.visibility_rounded,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // edit task
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskScreen(
                              flag: 'update',
                              label: widget.label,
                              id: widget.tasklist.id,
                              title: widget.tasklist.title,
                              notes: widget.tasklist.notes,
                              status: widget.tasklist.status,
                              level: widget.tasklist.level,
                              time: widget.tasklist.time,
                              date: widget.tasklist.date,
                              categoryId:
                                  widget.tasklist.category_list_id.toString(),
                              searchString: widget.searchString ?? '',
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Platform.isIOS
                            ? CupertinoIcons.pencil_circle
                            : Icons.edit_rounded,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // delete task
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: 'Are you sure?',
                          text:
                              '\'${widget.tasklist.title}\' information will be lost forever.',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          onCancelBtnTap: () => {
                            Navigator.of(context).pop(),
                          },
                          onConfirmBtnTap: () {
                            final catid = widget.tasklist.category_list_id!;
                            context.read<TasksBloc>().add(
                                  DeleteTask(
                                    tasks: widget.tasklist,
                                  ),
                                );
                            context.read<TasksBloc>().add(
                                  ReadTask(categoryid: catid),
                                );
                            if (widget.searchString != null &&
                                widget.searchString != '') {
                              context.read<TasksSearchBloc>().add(
                                    ReadTaskSearch(q: widget.searchString!),
                                  );
                            }
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      icon: Icon(
                        Platform.isIOS
                            ? CupertinoIcons.delete
                            : Icons.delete_rounded,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      humanReadableDateTime(widget.tasklist.timestamp),
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
  }
}
