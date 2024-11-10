import 'package:ARMOYU/app/modules/poll/poll_detail/controllers/poll_detail_controller.dart';
import 'package:get/get.dart';

class PollDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PollDetailController>(() => PollDetailController());
  }
}
