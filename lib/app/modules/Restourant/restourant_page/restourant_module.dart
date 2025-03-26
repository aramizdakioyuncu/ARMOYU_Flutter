import 'package:armoyu/app/modules/Restourant/restourant_page/bindings/restourant_binding.dart';
import 'package:armoyu/app/modules/Restourant/restourant_page/views/restourant_view.dart';
import 'package:get/get.dart';

class RestourantModule {
  static const route = '/restourant';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const RestourantView(),
      binding: RestourantBinding(),
    ),
  ];
}
