import 'package:armoyu/app/modules/utils/noconnectionpage/bindings/noconnection_binding.dart';
import 'package:armoyu/app/modules/utils/noconnectionpage/views/noconnection_view.dart';
import 'package:get/get.dart';

class NoconnectionpageModule {
  static const route = '/noconnection';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const NoConnectionpageView(),
      binding: NoconnectionpageBinding(),
    ),
  ];
}
