import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PostdetailController extends GetxController {
  var commentheight = Rx<double>(0);
  var controllerMessage = TextEditingController().obs;
  var listComments = <Widget>[].obs;

  // var currentUserAccounts =
  //     Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));
  var postID = Rx<int?>(null);
  var commentID = Rx<int?>(null);

  late PostsWidgetBundle widgetposts;

  @override
  void onInit() {
    super.onInit();
    //* *//
    // final findCurrentAccountController = Get.find<AccountUserController>();
    // currentUserAccounts.value =
    //     findCurrentAccountController.currentUserAccounts.value;
    //* *//

    Map<String, dynamic> arguments = Get.arguments;
    postID.value = arguments['postID'];
    commentID.value = arguments['commentID'];
    log(commentID.value.toString());

    widgetposts = API.widgets.social.posts(
      context: Get.context!,
      shrinkWrap: true,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {
        log('$userID $username');
        PageFunctions().pushProfilePage(
          Get.context!,
          User(
            userID: userID,
            userName: Rx(username),
          ),
        );
      },
    );
  }
}
