import 'package:ARMOYU/app/modules/Restourant/restourant_page/controllers/restourant_controller.dart';
import 'package:get/get.dart';

class RestourantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestourantController>(() => RestourantController());
  }
}
