import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.dark();

  ThemeData get themeData => _themeData;

  void darkMode(SharedPreferences prefs) {
    prefs.setString('thememode', "dark");
    _themeData = ThemeData.dark();

    // ARMOYU.textColor = const Color.fromARGB(255, 255, 255, 255);
    ARMOYU.textbackColor = Colors.grey.shade900;
    ARMOYU.texthintColor = const Color.fromARGB(255, 195, 195, 195);

    ARMOYU.baseColor = const Color.fromARGB(255, 169, 169, 169);
    ARMOYU.highlightColor = Colors.grey[900]!;

    ARMOYU.color = Colors.white;
    // ARMOYU.appbarColor = Colors.black;
    ARMOYU.appbottomColor = Colors.black;
    ARMOYU.bodyColor = Colors.grey.shade900;
    ARMOYU.backgroundcolor = Colors.black;
    ARMOYU.buttonColor = Colors.grey.shade900;
  }

  void lightMode(SharedPreferences prefs) {
    prefs.setString('thememode', "light");
    _themeData = ThemeData.light();

    // ARMOYU.textColor = Colors.black;
    ARMOYU.textbackColor = Colors.grey.shade100;
    ARMOYU.texthintColor = const Color.fromARGB(255, 169, 169, 169);

    ARMOYU.baseColor = Colors.grey[300]!;
    ARMOYU.highlightColor = Colors.grey[100]!;

    ARMOYU.color = Colors.black;
    // ARMOYU.appbarColor = Colors.white;
    ARMOYU.appbottomColor = Colors.white;

    ARMOYU.bodyColor = Colors.grey.shade100;
    ARMOYU.backgroundcolor = Colors.white;
    ARMOYU.buttonColor = Colors.blue;
  }

  Future<void> startingTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark" || thememode.toString() == "null") {
      darkMode(prefs);
    } else {
      lightMode(prefs);
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final thememode = prefs.getString('thememode');

    if (thememode.toString() == "dark") {
      log("$thememode => light");
      lightMode(prefs);
    } else {
      log("$thememode => dark");
      darkMode(prefs);
    }

    notifyListeners();
  }
}

const a = Color.fromRGBO(1, 1, 1, 1);
