import 'package:ARMOYU/app/modules/utils/camera/views/cam_view.dart';
import 'package:get/get.dart';

class CamModule {
  static const route = '/camera';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const CamView(),
      // binding: CameraBinding(),
    ),
  ];
}
