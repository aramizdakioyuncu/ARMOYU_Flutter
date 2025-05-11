import 'package:armoyu/app/modules/pages/mainpage/profile_page/friends_page/controllers/profile_friendlist_controller.dart';
import 'package:get/get.dart';

class ProfileFirendlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileFriendlistController>(
        () => ProfileFriendlistController());
  }
}
