import 'package:ARMOYU/app/modules/poll/poll_create/controllers/poll_create_controller.dart';
import 'package:get/get.dart';

class PollCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PollCreateController>(() => PollCreateController());
  }
}
