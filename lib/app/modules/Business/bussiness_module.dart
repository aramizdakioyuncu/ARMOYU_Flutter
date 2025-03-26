import 'package:armoyu/app/modules/Business/applications_page/bindings/applications_binding.dart';
import 'package:armoyu/app/modules/Business/applications_page/views/applications_view.dart';
import 'package:armoyu/app/modules/Business/joinus_page/bindings/joinus_binding.dart';
import 'package:armoyu/app/modules/Business/joinus_page/views/joinus_view.dart';
import 'package:get/get.dart';

class BussinessModule {
  static const route = '/applications';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ApplicationsView(),
      binding: ApplicationsBinding(),
    ),
    GetPage(
      name: "$route/create",
      page: () => const JoinusView(),
      binding: JoinusBinding(),
    ),
  ];
}
