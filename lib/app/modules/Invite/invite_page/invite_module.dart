import 'package:armoyu/app/modules/Invite/invite_page/bindings/invite_binding.dart';
import 'package:armoyu/app/modules/Invite/invite_page/views/invite_view.dart';
import 'package:get/get.dart';

class InviteModule {
  static const route = '/invite';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const InviteView(),
      binding: InviteBinding(),
    ),
  ];
}
