// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.dark();

  ThemeData get themeData => _themeData;
  Future<void> StartingTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark") {
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light();
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark") {
      _themeData = ThemeData.light();
      prefs.setString('thememode', "light");
      print(thememode.toString() + " => light");
    } else {
      _themeData = ThemeData.dark();
      prefs.setString('thememode', "dark");
      print(thememode.toString() + " => dark");
    }

    notifyListeners();
  }
}
