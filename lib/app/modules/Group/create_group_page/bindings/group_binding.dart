import 'package:ARMOYU/app/modules/Group/create_group_page/views/group_create.dart';
import 'package:get/get.dart';

class GroupCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupCreateView>(() => const GroupCreateView());
  }
}
