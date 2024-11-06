import 'package:ARMOYU/app/translations/en.dart';
import 'package:ARMOYU/app/translations/tr.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationKeys = {
    'en': en,
    'tr': tr,
  };
}
