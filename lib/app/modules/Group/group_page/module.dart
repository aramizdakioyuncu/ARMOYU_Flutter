import 'package:ARMOYU/app/modules/Group/group_page/bindings/group_page_binding.dart';
import 'package:ARMOYU/app/modules/Group/group_page/views/group_page_view.dart';
import 'package:get/get.dart';

class GroupPageModule {
  static const route = '/group';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/detail",
      page: () => const GroupPageView(),
      binding: GroupPageBinding(),
    ),
  ];
}
