import 'package:ARMOYU/app/modules/Group/create_group_page/bindings/group_binding.dart';
import 'package:ARMOYU/app/modules/Group/create_group_page/views/group_create_view.dart';
import 'package:ARMOYU/app/modules/Group/_main/bindings/group_binding.dart';
import 'package:ARMOYU/app/modules/Group/_main/views/group_view.dart';
import 'package:get/get.dart';

class GroupModule {
  static const route = '/group';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/detail",
      page: () => const GroupView(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: "$route/create",
      page: () => const GroupCreateView(),
      binding: GroupCreateBinding(),
    ),
  ];
}
