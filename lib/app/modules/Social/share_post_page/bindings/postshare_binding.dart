import 'package:armoyu/app/modules/Social/share_post_page/controllers/postshare_controller.dart';
import 'package:get/get.dart';

class PostshareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostshareController>(() => PostshareController());
  }
}
