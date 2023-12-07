// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:developer';

import 'package:ARMOYU/Core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.dark();

  ThemeData get themeData => _themeData;
  Future<void> StartingTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark" || thememode.toString() == "null") {
      _themeData = ThemeData.dark();
      prefs.setString('thememode', "dark");

      AppCore.textColor = Colors.white;
      AppCore.textbackColor = const Color.fromARGB(255, 255, 255, 255);
      AppCore.texthintColor = Color.fromARGB(255, 169, 169, 169);
    } else {
      _themeData = ThemeData.light();
      prefs.setString('thememode', "light");

      AppCore.textColor = Colors.black;
      AppCore.textbackColor = Color.fromARGB(255, 169, 169, 169);
      AppCore.texthintColor = Color.fromARGB(255, 169, 169, 169);
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark") {
      _themeData = ThemeData.light();
      prefs.setString('thememode', "light");
      log(thememode.toString() + " => light");

      AppCore.textColor = Color.fromARGB(255, 188, 205, 60);
      AppCore.textbackColor = Color.fromARGB(255, 14, 12, 16);
      AppCore.texthintColor = Color.fromARGB(255, 169, 169, 169);
    } else {
      _themeData = ThemeData.dark();
      prefs.setString('thememode', "dark");
      log(thememode.toString() + " => dark");

      AppCore.textColor = Color.fromARGB(255, 200, 18, 18);
      AppCore.textbackColor = const Color.fromARGB(255, 255, 255, 255);
      AppCore.texthintColor = Color.fromARGB(255, 169, 169, 169);
    }

    notifyListeners();
  }
}
