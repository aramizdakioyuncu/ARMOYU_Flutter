import 'package:ARMOYU/app/modules/poll/_main/controllers/poll_controller.dart';
import 'package:get/get.dart';

class PollBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PollController>(() => PollController());
  }
}
