import 'package:armoyu/app/modules/Settings/SettingsPage/devicepermission/controllers/devicepermission_settings_controller.dart';
import 'package:get/get.dart';

class DevicepermissionSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevicepermissionSettingsController>(
        () => DevicepermissionSettingsController());
  }
}
