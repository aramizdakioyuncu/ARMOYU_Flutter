import 'dart:developer';

import 'package:ARMOYU/app/modules/pages/mainpage/Profile/friends_page/controllers/profile_friendlist_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/userlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFriendlistView extends StatelessWidget {
  const ProfileFriendlistView({super.key});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    final controller = Get.put(
      ProfileFriendlistController(),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomText.costum1(
          controller.user.value.user.value.userName.toString(),
        ),
      ),
      body: CustomScrollView(
        controller: controller.scrollController.value,
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => controller.fetchfriend(refreshfetch: true),
          ),
          Obx(() => controller.user.value.user.value.myFriends == null
              ? const SliverFillRemaining(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : controller.user.value.user.value.myFriends!.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(CommonKeys.empty.tr),
                      ),
                    )
                  : SliverList.builder(
                      itemCount:
                          controller.user.value.user.value.myFriends!.length,
                      itemBuilder: (context, index) {
                        return UserListWidget(
                          currentUserAccounts: controller.user.value,
                          userID: controller
                              .user.value.user.value.myFriends![index].userID!,
                          displayname: controller.user.value.user.value
                              .myFriends![index].displayName!.value,
                          profileImageUrl: controller.user.value.user.value
                              .myFriends![index].avatar!.mediaURL.minURL.value,
                          username: controller.user.value.user.value
                              .myFriends![index].userName!.value,
                          isFriend: controller.user.value.user.value
                              .myFriends![index].ismyFriend!.value,
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
