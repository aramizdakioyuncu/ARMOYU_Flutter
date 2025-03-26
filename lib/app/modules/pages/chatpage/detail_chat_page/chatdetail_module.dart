import 'package:armoyu/app/modules/pages/chatpage/detail_chat_page/views/chatdetail_view.dart';
import 'package:get/get.dart';

class ChatdetailModule {
  static const route = '/chat';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/detail",
      page: () => const ChatdetailView(),
    ),
  ];
}
