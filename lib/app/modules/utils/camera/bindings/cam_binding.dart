import 'package:ARMOYU/app/modules/utils/camera/controllers/cam_controller.dart';
import 'package:get/get.dart';

class CamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CamController>(() => CamController());
  }
}
