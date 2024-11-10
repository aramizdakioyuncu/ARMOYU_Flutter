import 'package:ARMOYU/app/modules/Group/create_group_page/controllers/group_create_controller.dart';
import 'package:get/get.dart';

class GroupCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupCreateController>(() => GroupCreateController());
  }
}
