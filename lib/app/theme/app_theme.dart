import 'package:flutter/material.dart';

final ThemeData appDarkThemeData = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
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
    fillColor: WidgetStatePropertyAll(Colors.black26),
    checkColor: WidgetStatePropertyAll(Colors.red),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
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
  snackBarTheme: SnackBarThemeData(
    backgroundColor: (Colors.grey.shade900),
    contentTextStyle: const TextStyle(
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

//LIGHT THEME
//LIGHT THEME
//LIGHT THEME
final ThemeData appLightThemeData = ThemeData.light().copyWith(
  primaryColor: Colors.black,
  indicatorColor: Colors.amber,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    foregroundColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.grey.shade500),
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.grey.shade900,
  ),
  badgeTheme: BadgeThemeData(
    textColor: Colors.grey.shade900,
  ),

  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Colors.red),
    trackColor: WidgetStatePropertyAll(Colors.white),
  ),
  radioTheme: const RadioThemeData(
    fillColor: WidgetStatePropertyAll(Colors.red),
  ),
  checkboxTheme: const CheckboxThemeData(
    fillColor: WidgetStatePropertyAll(Colors.black26),
    checkColor: WidgetStatePropertyAll(Colors.red),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    iconColor: Colors.grey.shade900,
    prefixIconColor: Colors.grey.shade900,
    fillColor: Colors.grey.shade300,
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
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
      iconColor: WidgetStateProperty.all(Colors.black),
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF3C4CBD),
    contentTextStyle: TextStyle(
      color: Colors.black,
    ),
    actionTextColor: Colors.yellow,
  ),
  // drawerTheme: const DrawerThemeData(
  //   backgroundColor: Colors.white,
  //   scrimColor: Colors.white,
  //   shadowColor: Colors.white,
  //   surfaceTintColor: Colors.white,
  // ),
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
    color: Colors.white,
    thickness: 0,
    endIndent: 0,
    indent: 0,
    space: 0,
  ),

  cardColor: Colors.grey.shade400,
  listTileTheme: const ListTileThemeData(
    textColor: Colors.black,
    iconColor: Colors.black,
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    textColor: Colors.black,
    collapsedTextColor: Colors.black,
    collapsedIconColor: Colors.black,
    iconColor: Colors.red,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  primaryTextTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
  ),
);
