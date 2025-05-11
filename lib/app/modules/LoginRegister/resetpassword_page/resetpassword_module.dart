import 'package:armoyu/app/modules/LoginRegister/resetpassword_page/views/resetpassword_view.dart';
import 'package:get/get.dart';

class ResetPasswordModule {
  static const route = '/ressetpassword';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const ResetPasswordpageView(),
    ),
  ];
}
