import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsAccountStatusPage extends StatefulWidget {
  final User currentUser;
  const SettingsAccountStatusPage({
    super.key,
    required this.currentUser,
  });

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
      appBar: AppBar(
        title: Text(SettingsKeys.accountStatus.tr),
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
                    backgroundColor: Colors.transparent,
                    foregroundImage: CachedNetworkImageProvider(
                      widget.currentUser.avatar!.mediaURL.minURL.value,
                    ),
                    radius: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText.costum1(widget.currentUser.displayName!,
                        weight: FontWeight.bold, size: 22),
                  ),
                  RichText(
                    textAlign:
                        TextAlign.center, // Bu, metnin genel hizasını belirler
                    text: TextSpan(
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16), // Stil ayarları (isteğe bağlı)
                      children: <TextSpan>[
                        TextSpan(
                          text: AccountStatusKeys
                              .accountStatusabout.tr, // İkinci satır
                          style: const TextStyle(
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
                  title: CustomText.costum1(
                      AccountStatusKeys.removedContentExplain.tr),
                  subtitle:
                      CustomText.costum1(AccountStatusKeys.removedContent.tr),
                  tileColor: Get.theme.scaffoldBackgroundColor,
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
                  title:
                      CustomText.costum1(AccountStatusKeys.myRestrictions.tr),
                  subtitle: CustomText.costum1(
                      AccountStatusKeys.myRestrictionsExplain.tr),
                  tileColor: Get.theme.scaffoldBackgroundColor,
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
