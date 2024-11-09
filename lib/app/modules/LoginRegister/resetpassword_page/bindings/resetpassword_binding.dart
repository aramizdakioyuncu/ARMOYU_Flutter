import 'package:ARMOYU/app/modules/LoginRegister/resetpassword_page/controllers/resetpassword_controller.dart';
import 'package:get/get.dart';

class ResetPasswordpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetpasswordController>(() => ResetpasswordController());
  }
}
