import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/sources/reels/bundle/reels_bundle.dart';
import 'package:get/get.dart';

class MainReelsController extends GetxController {
  late ReelsWidgetBundle reelsWidgetBundle;
  @override
  void onInit() {
    super.onInit();

    reelsWidgetBundle = API.widgets.reels.reels(
      Get.context!,
      profileFunction: (
          {required avatar,
          required banner,
          required displayname,
          required userID,
          required username}) {},
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
