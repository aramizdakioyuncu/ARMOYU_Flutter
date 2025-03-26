import 'package:armoyu/app/modules/News/news_page/controllers/news_page_controller.dart';
import 'package:get/get.dart';

class NewsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsPageController>(() => NewsPageController());
  }
}
