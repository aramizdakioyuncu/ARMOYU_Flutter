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

      AppCore.textColor = const Color.fromARGB(255, 255, 255, 255);
      AppCore.textbackColor = Color.fromARGB(255, 56, 56, 56);
      AppCore.texthintColor = Color.fromARGB(255, 195, 195, 195);
    } else {
      _themeData = ThemeData.light();
      prefs.setString('thememode', "light");

      AppCore.textColor = Colors.black;
      AppCore.textbackColor = Color.fromARGB(255, 193, 193, 193);
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

      AppCore.textColor = Colors.black;
      AppCore.textbackColor = Color.fromARGB(255, 193, 193, 193);
      AppCore.texthintColor = Color.fromARGB(255, 169, 169, 169);
    } else {
      _themeData = ThemeData.dark();
      prefs.setString('thememode', "dark");
      log(thememode.toString() + " => dark");

      AppCore.textColor = const Color.fromARGB(255, 255, 255, 255);
      AppCore.textbackColor = Color.fromARGB(255, 56, 56, 56);
      AppCore.texthintColor = Color.fromARGB(255, 195, 195, 195);
    }

    notifyListeners();
  }
}

const a = Color.fromRGBO(1, 1, 1, 1);
