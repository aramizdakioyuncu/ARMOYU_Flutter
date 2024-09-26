import 'package:ARMOYU/app/modules/News/news_page/views/news_page.dart';
import 'package:get/get.dart';

class NewsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsPageView>(() => const NewsPageView());
  }
}
