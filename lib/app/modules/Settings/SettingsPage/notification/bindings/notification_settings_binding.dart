import 'package:armoyu/app/modules/Settings/SettingsPage/notification/controllers/notification_settings_controller.dart';
import 'package:get/get.dart';

class NotificationsettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsettingsController>(
        () => NotificationsettingsController());
  }
}
