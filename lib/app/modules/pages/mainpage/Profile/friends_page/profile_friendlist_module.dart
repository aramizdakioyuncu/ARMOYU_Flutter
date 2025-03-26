import 'package:armoyu/app/modules/pages/mainpage/Profile/friends_page/bindings/profile_firendlist_binding.dart';
import 'package:armoyu/app/modules/pages/mainpage/Profile/friends_page/views/profile_friendlist_view.dart';
import 'package:get/get.dart';

class ProfileFriendlistModule {
  static const route = '/profile';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/friendlist",
      page: () => const ProfileFriendlistView(),
      binding: ProfileFirendlistBinding(),
    ),
  ];
}
