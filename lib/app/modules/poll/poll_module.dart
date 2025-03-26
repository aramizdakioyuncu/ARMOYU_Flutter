import 'package:armoyu/app/modules/poll/_main/bindings/poll_binding.dart';
import 'package:armoyu/app/modules/poll/_main/views/poll_view.dart';
import 'package:armoyu/app/modules/poll/poll_create/bindings/poll_create_binding.dart';
import 'package:armoyu/app/modules/poll/poll_create/views/poll_create_view.dart';
import 'package:armoyu/app/modules/poll/poll_detail/bindings/poll_detail_binding.dart';
import 'package:armoyu/app/modules/poll/poll_detail/views/poll_detail_view.dart';
import 'package:get/get.dart';

class PollModule {
  static const route = '/poll';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const PollView(),
      binding: PollBinding(),
    ),
    GetPage(
      name: "$route/detail",
      page: () => const PollDetailView(),
      binding: PollDetailBinding(),
    ),
    GetPage(
      name: "$route/create",
      page: () => const PollCreateView(),
      binding: PollCreateBinding(),
    ),
  ];
}
