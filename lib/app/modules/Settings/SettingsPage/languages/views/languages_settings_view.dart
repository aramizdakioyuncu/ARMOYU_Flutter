import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguagesSettingsView extends StatelessWidget {
  const LanguagesSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsKeys.languages.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: List.generate(
                AppTranslation.translationKeys.entries.length,
                (index) {
                  var language = AppTranslation.translationKeys.entries
                      .elementAt(index)
                      .key;
                  var languageshort = AppTranslation.translationKeys.entries
                      .elementAt(index)
                      .value
                      .entries;
                  return ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(
                      languageshort.first.value,
                    ),
                    onTap: () {
                      if (language == 'tr') {
                        Get.updateLocale(const Locale('tr', 'TR'));
                      } else if (language == 'en') {
                        Get.updateLocale(const Locale('en', 'US'));
                      }
                    },
                    selected: SettingsKeys.currentLanguage.tr ==
                        languageshort.first.value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
