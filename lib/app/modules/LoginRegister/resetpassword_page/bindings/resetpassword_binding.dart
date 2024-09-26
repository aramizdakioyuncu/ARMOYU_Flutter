import 'package:ARMOYU/app/modules/LoginRegister/resetpassword_page/views/resetpassword_view.dart';
import 'package:get/get.dart';

class ResetPasswordpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordpageView>(() => const ResetPasswordpageView());
  }
}
