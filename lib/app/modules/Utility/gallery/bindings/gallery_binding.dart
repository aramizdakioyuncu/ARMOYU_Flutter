import 'package:ARMOYU/app/modules/Utility/gallery/controllers/gallery_controller.dart';
import 'package:get/get.dart';

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(() => GalleryController());
  }
}
