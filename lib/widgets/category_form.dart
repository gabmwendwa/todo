import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:to_do/bloc_category/categories_bloc.dart';
import 'package:to_do/components/my_text_form_field.dart';
import 'package:to_do/database/models/category_list.dart';
import 'package:to_do/database/schema.dart';

class CategoryForm extends StatefulWidget {
  final String? title;
  final String? flag;
  final int? id;
  final CategoryList? categoryList;
  const CategoryForm({
    super.key,
    required this.title,
    required this.flag,
    this.id,
    this.categoryList,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final CategoryListSchema _categoryListSchema = CategoryListSchema();
  bool _isSubmitting = false;
  bool _isSaved = false;

  final _myTitleFocusNode = FocusNode();
  final _myTitleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myTitleController.text = widget.title!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _myTitleController.dispose();
    _myTitleFocusNode.dispose();
  }

// ----------------------- PRIMARY FUNCTIONS START -----------------------

  _submit() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_isSubmitting) {
      if (_formKey.currentState!.validate()) {
        Map<String, dynamic> row = {
          'title': _myTitleController.text.trim(),
          'timestamp': DateTime.now().toString()
        };
        debugPrint(
            '-------------> Category List Data Here: ${widget.categoryList}');
        debugPrint('-------------> Category Data Here: $row');
        debugPrint('-------------> Category ID Here: ${widget.id}');
        try {
          switch (widget.flag) {
            case 'create':
              _categoryListSchema.createCategory(row);
              break;
            default:
              _categoryListSchema.updateCategory(
                row,
                widget.id,
              );
              break;
          }
          context.read<CategoriesBloc>().add(
                ReadCategories(),
              );

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
            ),
            () {
              if (widget.flag == 'create') {
                _myTitleController.clear();
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
                  Navigator.of(context).pop(),
                  if (widget.flag == 'create')
                    {
                      Navigator.of(context).pop(),
                    }
                },
              );
            },
          );
        } catch (e) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Something went wrong!',
            text: 'Please try again.',
            barrierDismissible: false,
            onConfirmBtnTap: () => {
              _isSaved = false,
              _isSubmitting = false,
              Navigator.of(context).pop(),
            },
          );
          setState(() {
            _isSaved = true;
            _isSubmitting = false;
          });
          debugPrint('-------------> Exception Here: $e');
          return;
        }
      }
    }
  }

  _cancel() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_isSaved &&
        _myTitleController.text.isNotEmpty &&
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
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              MyTextFormField(
                focusNode: _myTitleFocusNode,
                textEditingController: _myTitleController,
                textLabel: 'My title',
                obscureText: false,
                prefixIcon: Platform.isIOS
                    ? CupertinoIcons.pencil_circle_fill
                    : Icons.edit_document,
                what: 'title',
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                readOnly: false,
              ),
              const Divider(
                height: 20.0,
              ),
              Row(
                children: [
                  SignInButtonBuilder(
                    text: widget.flag == 'edit' ? 'Close' : 'Cancel',
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
            ],
          ),
        ),
      ),
    );
  }
}
