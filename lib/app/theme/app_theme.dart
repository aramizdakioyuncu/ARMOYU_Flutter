import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  primaryColor: Colors.red,
  primarySwatch: Colors.amber,
  indicatorColor: Colors.amber,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.grey.shade900),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.white,
  ),
  badgeTheme: const BadgeThemeData(
    textColor: Colors.white,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: const WidgetStatePropertyAll(Colors.red),
    trackColor: WidgetStatePropertyAll(Colors.grey.shade900),
  ),
  radioTheme: const RadioThemeData(
    fillColor: WidgetStatePropertyAll(Colors.red),
  ),
  checkboxTheme: const CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(
    Colors.amber,
  )),
  inputDecorationTheme: InputDecorationTheme(
    iconColor: Colors.white,
    prefixIconColor: Colors.white,
    fillColor: Colors.grey.shade900,
    hintStyle: const TextStyle(
      color: Color.fromARGB(255, 195, 195, 195),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey.shade900,
    contentTextStyle: const TextStyle(
      color: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.red,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF3C4CBD),
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
    actionTextColor: Colors.yellow,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.black,
    scrimColor: Colors.black,
    shadowColor: Colors.black,
    surfaceTintColor: Colors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.white,
    thickness: 0,
    endIndent: 0,
    indent: 0,
    space: 0,
  ),
  cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
    brightness: Brightness.dark,
  ),
  cardColor: Colors.grey.shade900,
  listTileTheme: const ListTileThemeData(
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    textColor: Colors.white,
    collapsedTextColor: Colors.white,
    collapsedIconColor: Colors.white,
    iconColor: Colors.red,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
