import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.red,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Color(0xFF3C4CBD),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xFF3C4CBD)),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.red,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF3C4CBD), // SnackBar arka plan rengi
    contentTextStyle: TextStyle(
      color: Colors.white,
    ), // SnackBar metin rengi
    actionTextColor: Colors.yellow, //
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.black,
    thickness: 3,
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color(0xFF3C4CBD),
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
);
