import 'package:armoyu/app/modules/pages/mainpage/profile_page/profile_page/views/profile_view.dart';
import 'package:get/get.dart';

class ProfileModule {
  static const route = '/profile';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ProfileView(),
    ),
    // GetPage(
    //   name: "$route/admin",
    //   page: () => const AdminHomepageView(),
    //   binding: AdminHomepageBinding(),
    // ),
  ];
}
