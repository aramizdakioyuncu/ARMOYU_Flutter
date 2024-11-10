import 'package:ARMOYU/app/modules/utils/camera/bindings/camera_binding.dart';
import 'package:ARMOYU/app/modules/utils/camera/views/camera_view.dart';
import 'package:get/get.dart';

class CameraModule {
  static const route = '/camera';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
  ];
}
