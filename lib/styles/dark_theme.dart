import 'package:flutter/material.dart';
import 'package:to_do/styles/todo_theme.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'FredokaOne',
      fontSize: 25,
    ),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
  ),
  primaryColor: todoblue,
  primaryColorLight: Colors.grey[200],
  primaryColorDark: Colors.black,
  fontFamily: 'Poppins',
);
