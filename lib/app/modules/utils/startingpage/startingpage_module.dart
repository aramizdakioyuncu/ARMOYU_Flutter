import 'package:ARMOYU/app/modules/utils/startingpage/bindings/startingpage_binding.dart';
import 'package:ARMOYU/app/modules/utils/startingpage/views/startingpage_view.dart';
import 'package:get/get.dart';

class StartingpageModule {
  static const route = '/';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const StartingpageView(),
      binding: StartingpageBinding(),
    ),
  ];
}
