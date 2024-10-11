import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';

class SettingsHelpPage extends StatefulWidget {
  const SettingsHelpPage({super.key});

  @override
  State<SettingsHelpPage> createState() => _SettingsHelpPage();
}

class _SettingsHelpPage extends State<SettingsHelpPage> {
  bool lessdata = false;
  bool lessmedia = false;
  bool automedia = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        // backgroundColor: ARMOYU.appbarColor,
        title: const Text('Yardım'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1("Sorun Bildir"),
                  tileColor: ARMOYU.backgroundcolor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1("Destek Talepleri"),
                  tileColor: ARMOYU.backgroundcolor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
