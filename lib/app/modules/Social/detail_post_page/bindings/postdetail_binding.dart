import 'package:armoyu/app/modules/Social/detail_post_page/controllers/postdetail_controller.dart';
import 'package:get/get.dart';

class PostdetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostdetailController>(() => PostdetailController());
  }
}
