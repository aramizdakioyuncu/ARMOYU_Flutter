import 'package:armoyu/app/modules/pages/mainpage/Notification/friend_request_page/controllers/friendrequest_controller.dart';
import 'package:get/get.dart';

class FriendrequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendrequestController>(() => FriendrequestController());
  }
}
