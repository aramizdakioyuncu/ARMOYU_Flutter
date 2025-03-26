import 'package:armoyu/app/modules/LoginRegister/login_page/views/login_view.dart';
import 'package:get/get.dart';

class LoginpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginpageView>(() => const LoginpageView());
  }
}
