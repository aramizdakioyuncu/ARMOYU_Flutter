import 'package:ARMOYU/app/modules/Settings/SettingsPage/help/controllers/helpsettings_controller.dart';
import 'package:get/get.dart';

class HelpsettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpsettingsController>(() => HelpsettingsController());
  }
}
