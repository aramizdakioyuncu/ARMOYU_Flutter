import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/sources/social/bundle/postcreate_bundle.dart';
import 'package:get/get.dart';

class PostshareController extends GetxController {
  late final PostcreateWidgetBundle createPostWidget;

  @override
  void onInit() {
    createPostWidget = API.widgets.social.postcreate();

    super.onInit();
  }
}
