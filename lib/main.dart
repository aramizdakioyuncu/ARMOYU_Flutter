import 'package:ARMOYU/app/app.dart';

import 'package:ARMOYU/app/services/Utility/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const Portal(
        child: MyApp(),
      ),
    ),
  );
}
