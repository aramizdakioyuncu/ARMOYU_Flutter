import 'package:armoyu/app/modules/Story/story_screen_page/controllers/story_screen_controller.dart';
import 'package:get/get.dart';

class StoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryScreenController>(() => StoryScreenController());
  }
}
