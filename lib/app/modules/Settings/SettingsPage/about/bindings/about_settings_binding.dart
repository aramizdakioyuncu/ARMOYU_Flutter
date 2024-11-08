import 'package:ARMOYU/app/modules/Settings/SettingsPage/about/controllers/about_settings_controller.dart';
import 'package:get/get.dart';

class AboutSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutSettingsController>(() => AboutSettingsController());
  }
}
