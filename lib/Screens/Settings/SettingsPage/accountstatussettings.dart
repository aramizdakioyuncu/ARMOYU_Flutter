import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Services/appuser.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsAccountStatusPage extends StatefulWidget {
  const SettingsAccountStatusPage({super.key});

  @override
  State<SettingsAccountStatusPage> createState() =>
      _SettingsAccountStatusPage();
}

class _SettingsAccountStatusPage extends State<SettingsAccountStatusPage> {
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
        title: const Text('Hesap Durumu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(AppUser.avatar),
                    radius: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText().costum1(AppUser.displayName,
                        weight: FontWeight.bold, size: 22),
                  ),
                  RichText(
                    textAlign:
                        TextAlign.center, // Bu, metnin genel hizasını belirler
                    text: const TextSpan(
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16), // Stil ayarları (isteğe bağlı)
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'Hesabının veya içeriklerinde kurallara uygun olmayan işlemleri buradan takip edebilirsin', // İkinci satır
                          style: TextStyle(
                            color: Colors
                                .grey, // İkinci satırın renk ayarı (isteğe bağlı)
                            fontSize:
                                16, // İkinci satırın font büyüklüğü (isteğe bağlı)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_size_select_actual_rounded),
                  title: CustomText().costum1("Kaldırılan İçerikler"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green.shade400,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.report),
                  title: CustomText().costum1("Kısıtlanmaların"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green.shade400,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
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