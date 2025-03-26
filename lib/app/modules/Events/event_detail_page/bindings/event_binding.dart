import 'package:armoyu/app/modules/Events/event_detail_page/controllers/event_controller.dart';
import 'package:get/get.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }
}
