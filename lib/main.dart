import 'package:ARMOYU/app/app.dart';
import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Bellekteki verileri alıyoruz
  ARMOYU.sharedprefences = await SharedPreferences.getInstance();
  API.service.setup();

  runApp(
    const Portal(
      child: MyApp(),
    ),
  );
}
