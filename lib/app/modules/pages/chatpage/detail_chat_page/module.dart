import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/bindings/chatdetail_bindings.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/views/chatdetail_page.dart';
import 'package:get/get.dart';

class ChatdetailModule {
  static const route = '/chat';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/detail",
      page: () => const ChatDetailView(),
      binding: ChatdetailBindings(),
    ),
  ];
}
