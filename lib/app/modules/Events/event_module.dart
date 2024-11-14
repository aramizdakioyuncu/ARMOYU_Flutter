import 'package:ARMOYU/app/modules/Events/event_detail_page/bindings/event_binding.dart';
import 'package:ARMOYU/app/modules/Events/event_detail_page/views/event_view.dart';
import 'package:ARMOYU/app/modules/Events/_main/bindings/eventlist_binding.dart';
import 'package:ARMOYU/app/modules/Events/_main/views/eventlist_view.dart';
import 'package:get/get.dart';

class EventModule {
  static const route = '/event';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/detail",
      page: () => const EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: "$route/list",
      page: () => const EventlistPage(),
      binding: EventlistBinding(),
    ),
  ];
}
