import 'package:armoyu/app/modules/School/school_login/controllers/school_login_controller.dart';
import 'package:get/get.dart';

class SchoolLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolLoginController>(() => SchoolLoginController());
  }
}
