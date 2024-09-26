import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/views/profile_page.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileView>(() => const ProfileView());
  }
}
