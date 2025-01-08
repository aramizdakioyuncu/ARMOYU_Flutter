import 'package:ARMOYU/app/modules/pages/chatpage/call_chat_page/views/chatcall_view.dart';
import 'package:get/get.dart';

class ChatcallModule {
  static const route = '/chat';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/call",
      page: () => const ChatcallView(),
    ),
  ];
}
