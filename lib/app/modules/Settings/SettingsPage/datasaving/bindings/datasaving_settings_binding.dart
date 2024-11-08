import 'package:ARMOYU/app/modules/Settings/SettingsPage/datasaving/controllers/datasaving_settings_controller.dart';
import 'package:get/get.dart';

class DatasavingSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatasavingSettingsController>(
        () => DatasavingSettingsController());
  }
}
