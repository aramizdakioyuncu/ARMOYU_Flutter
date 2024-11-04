import 'package:ARMOYU/app/modules/Settings/_main/bindings/setttings_binding.dart';
import 'package:ARMOYU/app/modules/Settings/_main/views/settings_view.dart';
import 'package:get/get.dart';

class SettingsModule {
  static const route = '/settings';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SettingsView(),
      binding: SetttingsBinding(),
    ),
  ];
}
