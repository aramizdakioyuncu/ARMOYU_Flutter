import 'package:ARMOYU/app/modules/News/list_news_page/bindings/list_news_binding.dart';
import 'package:ARMOYU/app/modules/News/list_news_page/views/list_news_view.dart';
import 'package:get/get.dart';

class ListNewsModule {
  static const route = '/news';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ListNewsView(),
      binding: ListNewsBinding(),
    ),
  ];
}
