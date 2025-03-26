import 'package:armoyu/app/modules/Story/story_screen_page/bindings/story_screen_binding.dart';
import 'package:armoyu/app/modules/Story/story_screen_page/views/story_screen_view.dart';
import 'package:get/get.dart';

class StoryModule {
  static const route = '/story';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const StoryScreenView(),
      binding: StoryScreenBinding(),
    ),
    // GetPage(
    //   name: "$route/publish",
    //   page: () => const AdminHomepageView(),
    //   binding: AdminHomepageBinding(),
    // ),
  ];
}
