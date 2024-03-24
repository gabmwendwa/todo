import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do/functions/validation.dart';

class MyTextFormField extends StatefulWidget {
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
  final Widget? suffix;
  final Function(String)? onSubmit;
  final bool readOnly;
  final bool? autoFocus;

  const MyTextFormField({
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
    this.suffix,
    this.onSubmit,
    required this.readOnly,
    this.autoFocus,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
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
      autofocus: widget.autoFocus ?? false,
      initialValue: widget.initialVal,
      cursorColor: Theme.of(context).primaryColorLight,
      obscureText: passswordVisibility,
      style: const TextStyle(
        fontSize: 16.0,
      ),
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
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Icon(
            widget.prefixIcon,
          ),
        ),
        prefixIconColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.focused)
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight),
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
            width: 2.0,
          ),
        ),
        suffixIcon: widget.suffix,
      ),
      keyboardType: widget.textInputType ?? TextInputType.text,
      validator: (value) {
        debugPrint('-------------> $value');
        return formValidation(widget.what, value!);
      },
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      onFieldSubmitted: widget.onSubmit,
      readOnly: widget.readOnly,
    );
  }
}
