import 'package:ARMOYU/app/modules/LoginRegister/register_page/views/register_view.dart';
import 'package:get/get.dart';

class RegisterpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterpageView>(() => const RegisterpageView());
  }
}
