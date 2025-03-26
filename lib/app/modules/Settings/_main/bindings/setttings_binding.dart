import 'package:armoyu/app/modules/Settings/_main/controller/settings_controller.dart';
import 'package:get/get.dart';

class SetttingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
