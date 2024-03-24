import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do/functions/validation.dart';

class MyLargeTextFormField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final String textLabel;
  final bool obscureText;
  final IconData? prefixIcon;
  final String what;
  final TextInputAction textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization textCapitalization;
  final String? initialVal;
  final bool readOnly;

  const MyLargeTextFormField({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.textLabel,
    required this.obscureText,
    this.prefixIcon,
    required this.what,
    required this.textInputAction,
    this.textInputType,
    this.initialVal,
    required this.textCapitalization,
    required this.readOnly,
  });

  @override
  State<MyLargeTextFormField> createState() => _MyLargeTextFormFieldState();
}

class _MyLargeTextFormFieldState extends State<MyLargeTextFormField> {
  bool passswordVisibility = false;
  IconData pssvisibilty =
      Platform.isIOS ? CupertinoIcons.eye : Icons.visibility;

  @override
  void initState() {
    super.initState();
    passswordVisibility = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialVal,
      cursorColor: Theme.of(context).primaryColorLight,
      obscureText: passswordVisibility,
      style: const TextStyle(
        fontSize: 16.0,
      ),
      readOnly: widget.readOnly,
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        labelText: widget.textLabel,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.bold,
        ),
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        contentPadding: const EdgeInsets.all(7.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 3.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.5,
          ),
        ),
      ),
      keyboardType: widget.textInputType ?? TextInputType.text,
      validator: (value) {
        debugPrint('-------------> $value');
        return formValidation(widget.what, value!);
      },
      textInputAction: widget.textInputAction,
      minLines: 5,
      maxLines: 10,
      textCapitalization: widget.textCapitalization,
    );
  }
}
