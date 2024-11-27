import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:country_flags/country_flags.dart';
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
            Container(color: Get.theme.cardColor, height: 1),
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
                    // leading: const Icon(Icons.language),
                    leading: CountryFlag.fromCountryCode(
                      language == 'en'
                          ? 'us'
                          : language == 'ar'
                              ? 'SA'
                              : language,
                    ),
                    title: Text(
                      languageshort.first.value,
                    ),
                    onTap: () {
                      if (language == 'tr') {
                        Get.updateLocale(const Locale('tr', 'TR'));
                      } else if (language == 'en') {
                        Get.updateLocale(const Locale('en', 'US'));
                      } else if (language == 'ar') {
                        Get.updateLocale(const Locale('ar', 'AE'));
                      } else if (language == 'de') {
                        Get.updateLocale(const Locale('de', 'DE'));
                      } else if (language == 'ru') {
                        Get.updateLocale(const Locale('ru', 'RU'));
                      }
                    },
                    selected: TranslateKeys.currentLanguage.tr ==
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
