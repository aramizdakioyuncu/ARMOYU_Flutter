import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/controllers/chatdetail_controller.dart';
import 'package:get/get.dart';

class ChatdetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatdetailController>(() => ChatdetailController());
  }
}
