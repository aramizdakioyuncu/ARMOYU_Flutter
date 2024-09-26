import 'package:ARMOYU/app/modules/News/list_news_page/views/list_news_view.dart';
import 'package:get/get.dart';

class ListNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListNewsView>(() => const ListNewsView());
  }
}
