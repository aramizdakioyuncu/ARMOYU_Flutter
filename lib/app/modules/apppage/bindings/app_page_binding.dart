import 'package:ARMOYU/app/modules/apppage/views/app_page_view.dart';
import 'package:get/get.dart';

class AppPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppPageView>(() => const AppPageView());
  }
}
