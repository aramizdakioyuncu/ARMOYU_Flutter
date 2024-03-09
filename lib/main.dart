import 'package:ARMOYU/Core/AppCore.dart';

import 'package:ARMOYU/Services/Utility/theme.dart';
import 'package:ARMOYU/Screens/Utility/startingscreen_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(homePage: StartingScreen()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget homePage;
  const MyApp({
    Key? key,
    required this.homePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.startingTheme();

    Intl.defaultLocale = 'tr_TR';
    return MaterialApp(
      title: 'ARMOYU',
      theme: themeProvider.themeData,
      home: homePage,
      debugShowCheckedModeBanner: false,
      navigatorKey: AppCore.navigatorKey,
    );
  }
}
