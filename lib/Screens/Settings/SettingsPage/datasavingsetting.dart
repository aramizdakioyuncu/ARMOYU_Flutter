import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';

class SettingsDataSavingPage extends StatefulWidget {
  const SettingsDataSavingPage({super.key});

  @override
  State<SettingsDataSavingPage> createState() => _SettingsDataSavingPage();
}

class _SettingsDataSavingPage extends State<SettingsDataSavingPage> {
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
      backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text('Veri Tasarrufu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1("Daha az hücresel veri kullan"),
                  subtitle: CustomText.costum1(
                      "Sayfa sonuna gelmeden yeni sayfa yüklenmez"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: lessdata,
                        onChanged: (value) {
                          setState(() {
                            lessdata = !lessdata;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("En düşük kalitede medya yükle"),
                  subtitle: CustomText.costum1(
                      "Medyalar en düşük kalitede gösterilir bu can sıkıcı olabilir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: lessmedia,
                        onChanged: (value) {
                          setState(() {
                            lessmedia = !lessmedia;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Videoları otomatik olarak oynat"),
                  subtitle:
                      CustomText.costum1("Videolar otomatik olarak oynatılır"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: automedia,
                        onChanged: (value) {
                          setState(() {
                            automedia = !automedia;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
