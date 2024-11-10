import 'package:ARMOYU/app/modules/utils/camera/controllers/camera_controller.dart';
import 'package:get/get.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraController>(() => CameraController());
  }
}
