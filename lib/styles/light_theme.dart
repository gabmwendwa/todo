import 'package:flutter/material.dart';
import 'package:to_do/styles/todo_theme.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(
      color: Color(0xFF0D47A1),
    ),
    actionsIconTheme: IconThemeData(
      color: Color(0xFF0D47A1),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFF0D47A1),
      fontFamily: 'FredokaOne',
      fontSize: 25,
    ),
  ),
  // drawerTheme: const DrawerThemeData(backgroundColor: Colors.black, co),
  colorScheme: ColorScheme.light(
    background: Colors.grey[200]!,
    primary: Colors.grey[300]!,
    secondary: Colors.grey[100]!,
  ),
  primaryColor: todoblue,
  primaryColorLight: Colors.black54,
  primaryColorDark: Colors.black,
  fontFamily: 'Poppins',
);
