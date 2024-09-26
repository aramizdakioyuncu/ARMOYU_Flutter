import 'package:ARMOYU/app/modules/Group/create_group_page/bindings/group_binding.dart';
import 'package:ARMOYU/app/modules/Group/create_group_page/views/group_create.dart';
import 'package:get/get.dart';

class GroupCreateModule {
  static const route = '/group';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/create",
      page: () => const GroupCreateView(),
      binding: GroupCreateBinding(),
    ),
  ];
}
