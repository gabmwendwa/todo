import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:to_do/bloc_task_search/tasks_search_bloc.dart';
import 'package:to_do/bloc_tasks/tasks_bloc.dart';
import 'package:to_do/components/my_large_text_form_field.dart';
import 'package:to_do/components/my_text_form_field.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:to_do/core/constants.dart';
import 'package:to_do/database/schema.dart';

class TaskForm extends StatefulWidget {
  final String? flag;
  final String categoryId;
  final int? id;
  final String? title;
  final String? notes;
  final String? status;
  final int? level;
  final String? time;
  final String? date;
  final String? searchString;
  const TaskForm({
    super.key,
    this.flag,
    this.id,
    required this.categoryId,
    this.title,
    this.notes,
    this.status,
    this.level,
    this.time,
    this.date,
    this.searchString,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final TaskSchema _taskSchema = TaskSchema();
  bool _isSaved = false;

  final _myTitleFocusNode = FocusNode();
  final _myTitleController = TextEditingController();
  final _myPriorityController = TextEditingController();

  final _myNotesFocusNode = FocusNode();
  final _myNotesController = TextEditingController();

  bool _switchValue = false; // Initial switch value
  String _switchMessage = "Pending"; // Initial message

  // Function to change the message based on the switch value
  void changeMessage() {
    setState(() {
      if (_switchValue) {
        _switchMessage = "Complete";
      } else {
        _switchMessage = "Pending";
      }
    });
  }

  int? _priority;
  String? _time = 'Pick a Time';
  String? _day = 'Pick a Date';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _myTitleController.text = widget.title ?? '';
      _myNotesController.text = widget.notes ?? '';
      _priority = widget.level ?? 1;
      _myPriorityController.text = priorityLabelList.first;

      _time = widget.time != null && widget.time!.trim() != ''
          ? widget.time
          : 'Pick a Time'; // : widget.time;
      _day = widget.date != null && widget.date!.trim() != ''
          ? widget.date
          : 'Pick a Date'; // : widget.date;
      _switchValue =
          widget.status == 'Pending' || widget.status == null ? false : true;
      changeMessage();
    });
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      setState(() {
        _myPriorityController.text = widget.level == null
            ? priorityLabelList.first
            : priorityLabelList[widget.level! - 1];
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _myTitleFocusNode.dispose();
    _myTitleController.dispose();

    _myNotesFocusNode.dispose();
    _myNotesController.dispose();
  }

// ----------------------- PRIMARY FUNCTIONS START -----------------------

  _submit() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_isSubmitting) {
      if (_formKey.currentState!.validate()) {
        _isSubmitting = true;
        Map<String, dynamic> row = {
          'title': _myTitleController.text.trim(),
          'notes': _myNotesController.text.trim(),
          'status': _switchMessage,
          'level': _priority,
          'time': _time.toString().trim() == 'Pick a Time'
              ? ''
              : _time.toString().trim(),
          'date': _day.toString().trim() == 'Pick a Date'
              ? ''
              : _day.toString().trim(),
          'timestamp': DateTime.now().toString()
        };
        debugPrint('-------------> Task ID Here: ${widget.categoryId}');
        debugPrint('-------------> Task Data Here: $row');
        debugPrint('-------------> Category ID Here: ${widget.id}');
        try {
          switch (widget.flag) {
            case 'create':
              row['category_list_id'] = int.parse(widget.categoryId);
              _taskSchema.createTask(row);
              break;
            default:
              _taskSchema.updateTask(
                row,
                widget.id,
              );
              break;
          }
          context.read<TasksBloc>().add(
                ReadTask(
                  categoryid: int.parse(widget.categoryId),
                ),
              );
          if (widget.searchString != null && widget.searchString != '') {
            context.read<TasksSearchBloc>().add(
                  ReadTaskSearch(q: widget.searchString!),
                );
          }

          QuickAlert.show(
            context: context,
            type: QuickAlertType.loading,
            title: 'Saving',
            text: 'Please wait...',
            barrierDismissible: false,
          );
          Future.delayed(
              const Duration(
                seconds: 3,
              ), () {
            if (widget.flag == 'create') {
              setState(() {
                _myTitleController.clear();
                _myNotesController.clear();
                _myPriorityController.text = priorityLabelList.first;
                _priority = 1;
                _time = 'Pick a Time';
                _day = 'Pick a Date';
                _switchValue = false;
                changeMessage(); // Call the function to update the message
              });
            }
            _isSaved = true;
            _isSubmitting = false;
            Navigator.of(context).pop();

            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success',
              text: 'Information is saved.',
              barrierDismissible: false,
              onConfirmBtnTap: () => {
                _isSaved = false,
                _isSubmitting = false,
                Navigator.of(context).pop(),
              },
            );
          });
        } catch (e) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Something went wrong!',
            text: 'Please try again.',
          );
          setState(() {
            _isSaved = true;
            _isSubmitting = false;
          });
          debugPrint('-------------> Exception: $e');
          return;
        }
      }
    }
  }

  _cancel() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_isSaved &&
        (_myTitleController.text.isNotEmpty ||
            _myNotesController.text.isNotEmpty) &&
        widget.flag == 'create') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Are you sure?',
        text:
            'Unsaved information will be lost if you ${widget.flag == 'edit' ? 'close' : 'cancel'}.',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        onCancelBtnTap: () => {
          Navigator.of(context).pop(),
        },
        onConfirmBtnTap: () => {
          Navigator.of(context).pop(),
          Navigator.of(context).pop(),
        },
      );
    } else {
      Navigator.of(context).pop();
    }
  }

// ----------------------- PRIMARY FUNCTIONS END -----------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                // Title
                MyTextFormField(
                  focusNode: _myTitleFocusNode,
                  textEditingController: _myTitleController,
                  textLabel: 'My title',
                  obscureText: false,
                  prefixIcon: Platform.isIOS
                      ? CupertinoIcons.pencil_circle_fill
                      : Icons.edit_document,
                  what: 'title',
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: widget.categoryId == '' ? true : false,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // Notes
                MyLargeTextFormField(
                  focusNode: _myNotesFocusNode,
                  textEditingController: _myNotesController,
                  textLabel: 'My notes',
                  obscureText: false,
                  prefixIcon: Platform.isIOS
                      ? CupertinoIcons.pencil_circle_fill
                      : Icons.edit_document,
                  what: 'notes',
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: widget.categoryId == '' ? true : false,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Priority
                Row(
                  children: [
                    const Text(
                      'Priority:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (widget.categoryId != '') ...[
                      GestureDetector(
                        onTap: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            children: [
                              DropdownMenu<String>(
                                initialSelection: priorityList.first,
                                controller: _myPriorityController,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.
                                  debugPrint("Select -------------> $value");
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _priority = int.parse(value!);
                                  });
                                },
                                dropdownMenuEntries: priorityList
                                    .map<DropdownMenuEntry<String>>(
                                        (String value) {
                                  return DropdownMenuEntry<String>(
                                    value: value,
                                    label:
                                        priorityLabelList[int.parse(value) - 1],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        _myPriorityController.text,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Status
                if (widget.categoryId != '') ...[
                  SwitchListTile(
                    title: const Text('Status'), // The title of the ListTile
                    subtitle: Text(_switchMessage), // Optional subtitle
                    secondary: _switchValue
                        ? Icon(
                            Platform.isIOS
                                ? CupertinoIcons.lightbulb_fill
                                : Icons.lightbulb_rounded,
                          )
                        : Icon(
                            Platform.isIOS
                                ? CupertinoIcons.lightbulb
                                : Icons.lightbulb_outline_rounded,
                          ),
                    activeColor:
                        Theme.of(context).primaryColor, // Optional leading icon
                    value: _switchValue, // The current value of the switch
                    onChanged: (newValue) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // Callback when the switch is toggled
                      setState(() {
                        _switchValue = newValue;
                        changeMessage(); // Call the function to update the message
                      });
                    },
                  ),
                ] else ...[
                  Row(
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        _switchMessage,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
                const SizedBox(
                  height: 10.0,
                ),

                // Time
                if (widget.categoryId != '') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: 250,
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            picker.DatePicker.showTimePicker(
                              context,
                              showTitleActions: true,
                              currentTime: DateTime.now(),
                              locale: picker.LocaleType.en,
                              theme: picker.DatePickerTheme(
                                headerColor: Theme.of(context).primaryColor,
                                backgroundColor: Theme.of(context).primaryColor,
                                itemStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onChanged: (date) {
                                setState(() {
                                  _time =
                                      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                                });
                                debugPrint('change $date -> $_time');
                              },
                              onConfirm: (date) {
                                setState(() {
                                  _time =
                                      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                                });
                                debugPrint('confirm $date -> $_time');
                              },
                            );
                          },
                          child: Text(
                            _time!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: 70,
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _time = 'Pick a Time';
                              });
                            },
                            child: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.clear_circled
                                  : Icons.close_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (_time != 'Pick a Time') ...[
                  Row(
                    children: [
                      const Text(
                        'Time:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        _time!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
                const SizedBox(
                  height: 10.0,
                ),

                // Date
                if (widget.categoryId != '') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: 250,
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            picker.DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              theme: picker.DatePickerTheme(
                                headerColor: Theme.of(context).primaryColor,
                                backgroundColor: Theme.of(context).primaryColor,
                                itemStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              currentTime: DateTime.now(),
                              locale: picker.LocaleType.en,
                              onChanged: (date) {
                                setState(() {
                                  _day =
                                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}';
                                });
                                debugPrint(
                                    '------------> change $date -> $_day');
                              },
                              onConfirm: (date) {
                                setState(() {
                                  _day =
                                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}';
                                });
                                debugPrint(
                                    '------------> confirm $date -> $_day');
                              },
                            );
                          },
                          child: Text(
                            _day!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: 70,
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _day = 'Pick a Date';
                              });
                            },
                            child: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.clear_circled
                                  : Icons.close_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (_day != 'Pick a Date') ...[
                  Row(
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        _day!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                if (widget.categoryId != '') ...[
                  const Divider(
                    height: 50.0,
                  ),
                  Row(
                    children: [
                      SignInButtonBuilder(
                        text: 'Cancel',
                        fontSize: 15.0,
                        width: 120,
                        innerPadding: const EdgeInsets.only(left: 10.0),
                        onPressed: () {
                          _cancel();
                        },
                        elevation: 6.0,
                        height: 45,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                      ),
                      const Spacer(),
                      SignInButtonBuilder(
                        text: 'Save',
                        fontSize: 15.0,
                        width: 120,
                        innerPadding: const EdgeInsets.only(left: 20.0),
                        onPressed: () {
                          _submit();
                        },
                        elevation: 6.0,
                        height: 45,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
