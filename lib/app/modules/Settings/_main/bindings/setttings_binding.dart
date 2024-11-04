import 'package:ARMOYU/app/modules/Settings/_main/views/settings_view.dart';
import 'package:get/get.dart';

class SetttingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsView>(() => const SettingsView());
  }
}
