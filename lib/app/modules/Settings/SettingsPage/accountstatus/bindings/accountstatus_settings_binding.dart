import 'package:ARMOYU/app/modules/Settings/SettingsPage/accountstatus/controllers/accountstatus_settings_controller.dart';
import 'package:get/get.dart';

class AccountstatusSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountstatusSettingsController>(
        () => AccountstatusSettingsController());
  }
}
