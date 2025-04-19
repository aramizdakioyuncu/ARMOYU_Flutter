import 'package:armoyu/app/modules/Social/detail_post_page/bindings/postdetail_binding.dart';
import 'package:armoyu/app/modules/Social/detail_post_page/views/postdetail_view.dart';
import 'package:armoyu/app/modules/Social/share_post_page/views/postshare_view.dart';
import 'package:get/get.dart';

class SocailModule {
  static const route = '/social';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/share",
      page: () => const PostshareView(),
    ),
    GetPage(
      name: "$route/detail",
      page: () => const PostdetailView(),
      binding: PostdetailBinding(),
    ),
  ];
}
