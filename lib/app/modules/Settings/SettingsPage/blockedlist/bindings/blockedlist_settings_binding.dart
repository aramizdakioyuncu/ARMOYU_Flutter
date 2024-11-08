import 'package:ARMOYU/app/modules/Settings/SettingsPage/blockedlist/controllers/blockedlist_settings_controller.dart';
import 'package:get/get.dart';

class BlockedlistSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockedlistSettingsController>(
        () => BlockedlistSettingsController());
  }
}
