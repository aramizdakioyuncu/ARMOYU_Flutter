import 'package:ARMOYU/app/modules/pages/mainpage/Notification/group_request_page/controllers/grouprequest_controller.dart';
import 'package:get/get.dart';

class GrouprequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GrouprequestController>(() => GrouprequestController());
  }
}
