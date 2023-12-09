// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.dark();

  ThemeData get themeData => _themeData;

  void DarkMode(SharedPreferences prefs) {
    prefs.setString('thememode', "dark");
    _themeData = ThemeData.dark();

    ARMOYU.textColor = const Color.fromARGB(255, 255, 255, 255);
    ARMOYU.textbackColor = Colors.grey.shade900;
    ARMOYU.texthintColor = Color.fromARGB(255, 195, 195, 195);

    ARMOYU.color = Colors.white;
    ARMOYU.bacgroundcolor = Colors.grey.shade900;
    ARMOYU.appbarColor = Colors.black;
    ARMOYU.bodyColor = Colors.black;

    ARMOYU.buttonColor = Colors.black;
  }

  void LightMode(SharedPreferences prefs) {
    prefs.setString('thememode', "light");
    _themeData = ThemeData.light();

    ARMOYU.textColor = Colors.black;
    ARMOYU.textbackColor = Colors.grey.shade100;
    ARMOYU.texthintColor = Color.fromARGB(255, 169, 169, 169);

    ARMOYU.color = Colors.black;
    ARMOYU.bacgroundcolor = Colors.white;
    ARMOYU.appbarColor = Colors.white10;
    ARMOYU.bodyColor = Color.fromARGB(134, 242, 238, 238);
    ARMOYU.buttonColor = Colors.blue;
  }

  Future<void> StartingTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark" || thememode.toString() == "null") {
      DarkMode(prefs);
    } else {
      LightMode(prefs);
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark") {
      log(thememode.toString() + " => light");
      LightMode(prefs);
    } else {
      log(thememode.toString() + " => dark");
      DarkMode(prefs);
    }

    notifyListeners();
  }
}

const a = Color.fromRGBO(1, 1, 1, 1);
