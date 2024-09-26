import 'package:ARMOYU/app/modules/Utility/noconnectionpage/views/noconnection_view.dart';
import 'package:get/get.dart';

class NoconnectionpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoConnectionpageView>(() => const NoConnectionpageView());
  }
}
