import 'package:ARMOYU/app/modules/utils/startingpage/views/startingpage_view.dart';
import 'package:get/get.dart';

class StartingpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartingpageView>(() => const StartingpageView());
  }
}
