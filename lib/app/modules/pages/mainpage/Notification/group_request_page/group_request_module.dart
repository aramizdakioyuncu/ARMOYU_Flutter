import 'package:ARMOYU/app/modules/pages/mainpage/Notification/group_request_page/bindings/grouprequest_binding.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/group_request_page/views/grouprequest_page.dart';
import 'package:get/get.dart';

class GroupRequestModule {
  static const route = '/notifications';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/group-request",
      page: () => const GrouprequestView(),
      binding: GrouprequestBinding(),
    ),
  ];
}
