import 'package:ARMOYU/Core/AppCore.dart';

import 'package:ARMOYU/Services/Utility/theme.dart';
import 'package:ARMOYU/Screens/Utility/startingscreen_page.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.startingTheme();

    return MaterialApp(
      title: 'ARMOYU',
      theme: themeProvider.themeData,
      home: const StartingScreen(),
      debugShowCheckedModeBanner: false,
      navigatorKey: AppCore.navigatorKey,
    );
  }
}
