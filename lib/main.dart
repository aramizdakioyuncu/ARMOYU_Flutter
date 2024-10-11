import 'package:ARMOYU/app/app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const Portal(
      child: MyApp(),
    ),
  );
}
