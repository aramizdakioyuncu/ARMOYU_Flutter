import 'package:ARMOYU/app/modules/Settings/SettingsPage/languages/controllers/languages_settings_controller.dart';
import 'package:get/get.dart';

class LanguagesSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguagesSettingsController>(
        () => LanguagesSettingsController());
  }
}
