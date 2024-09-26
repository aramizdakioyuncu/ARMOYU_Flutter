import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/bindings/profile_binding.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/views/profile_page.dart';
import 'package:get/get.dart';

class ProfileModule {
  static const route = '/profile';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    // GetPage(
    //   name: "$route/admin",
    //   page: () => const AdminHomepageView(),
    //   binding: AdminHomepageBinding(),
    // ),
  ];
}
