import 'package:ARMOYU/app/modules/Events/_main/controllers/eventlist_controller.dart';
import 'package:get/get.dart';

class EventlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventlistController>(() => EventlistController());
  }
}
