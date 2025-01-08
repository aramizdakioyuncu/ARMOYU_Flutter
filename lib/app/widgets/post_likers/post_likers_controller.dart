import 'package:armoyu_widgets/data/models/user.dart';
import 'package:get/get.dart';

class PostLikersController extends GetxController {
  final User user;
  final String date;
  int islike;
  PostLikersController({
    required this.user,
    required this.date,
    required this.islike,
  });

  // @override
  // void onInit() {
  //   super.onInit();
  // }
}
