import 'package:armoyu/app/modules/News/news_page/bindings/news_page_binding.dart';
import 'package:armoyu/app/modules/News/news_page/views/news_page.dart';
import 'package:get/get.dart';

class NewsPageModule {
  static const route = '/news/detail';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const NewsPageView(),
      binding: NewsPageBinding(),
    ),
  ];
}
