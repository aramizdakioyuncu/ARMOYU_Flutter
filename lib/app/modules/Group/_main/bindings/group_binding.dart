import 'package:armoyu/app/modules/Group/_main/views/group_view.dart';
import 'package:get/get.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupView>(() => const GroupView());
  }
}
