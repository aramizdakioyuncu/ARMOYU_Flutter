import 'package:ARMOYU/app/modules/apppage/bindings/app_page_binding.dart';
import 'package:ARMOYU/app/modules/apppage/views/app_page_view.dart';
import 'package:get/get.dart';

class AppPageModule {
  static const route = '/app';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const AppPageView(),
      binding: AppPageBinding(),
    ),
  ];
}
