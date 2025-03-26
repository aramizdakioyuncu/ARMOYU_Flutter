import 'package:armoyu/app/modules/News/list_news_page/controllers/list_news_controller.dart';
import 'package:get/get.dart';

class ListNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListNewsController>(() => ListNewsController());
  }
}
