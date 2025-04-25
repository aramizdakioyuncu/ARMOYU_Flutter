import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:get/get.dart';

class ChatcallController extends GetxController {
  var chat = Rx<Chat?>(null);
  bool call = false;
  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> arguments = Get.arguments;

    chat.value = arguments['chat'];
    call = arguments['type'] == "call" ? true : false;
  }
}
