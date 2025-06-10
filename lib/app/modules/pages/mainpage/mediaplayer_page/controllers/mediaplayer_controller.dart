import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/sources/players/bundle/musicplayer_bundle.dart';
import 'package:get/get.dart';

class MediaplayerController extends GetxController {
  late PlayerWidgetBundle player;

  @override
  void onInit() {
    super.onInit();

    player = API.widgets.players.advencedPlayer(Get.context!);
  }
}
