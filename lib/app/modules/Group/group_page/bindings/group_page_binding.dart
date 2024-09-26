import 'package:ARMOYU/app/modules/Group/group_page/views/group_page_view.dart';
import 'package:get/get.dart';

class GroupPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupPageView>(() => const GroupPageView());
  }
}
