import 'package:ARMOYU/app/modules/Utility/gallery/bindings/gallery_binding.dart';
import 'package:ARMOYU/app/modules/Utility/gallery/views/gallery_view.dart';
import 'package:get/get.dart';

class GalleryModule {
  static const route = '/gallery';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const GalleryView(),
      binding: GalleryBinding(),
    ),
  ];
}
