import 'package:armoyu/app/modules/pages/mainpage/Notification/friend_request_page/views/friendrequest_page.dart';
import 'package:get/get.dart';

class FriendRequstModule {
  static const route = '/notifications';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/friend-request",
      page: () => const FriendRequestView(),
    ),
  ];
}
