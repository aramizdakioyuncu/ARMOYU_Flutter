import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/profile/profile_invitelist.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InviteController extends GetxController {
  var isfirstfetch = true.obs;
  var newsfetchProcess = false.obs;
  var authroizedUserCount = 0.obs;
  var unauthroizedUserCount = 0.obs;
  var invitelist = [].obs;
  var invitePage = 1.obs;
  var inviteListProcces = false.obs;

  var scrollController = ScrollController().obs;
  var shouldShowTitle = true.obs;
  late var currentUserAccounts = Rxn<UserAccounts>();

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    if (isfirstfetch.value) {
      invitepeoplelist();
    }

    scrollController.value.addListener(() {
      if (scrollController.value.offset > (Get.height * 0.25 / 2)) {
        shouldShowTitle.value = false; // Başlık görünürlüğünü false yap
      } else {
        shouldShowTitle.value = true; // Başlık görünürlüğünü true yap
      }
    });
  }

  Future<void> refreshInviteCode() async {
    ServiceResult response =
        await API.service.profileServices.invitecoderefresh();

    if (!response.status) {
      log(response.description);
      return;
    }
    currentUserAccounts.value!.user.value.detailInfo!.value!.inviteCode.value =
        response.descriptiondetail;

    currentUserAccounts.value!.user.refresh();
  }

  Future<void> sendmailURL(int userID) async {
    ServiceResult response =
        await API.service.profileServices.sendauthmailURL(userID: userID);
    if (!response.status) {
      log(response.description);
      return;
    }

    ARMOYUWidget.stackbarNotification(Get.context!, response.description);
  }

  Future<void> invitepeoplelist() async {
    if (inviteListProcces.value == true) {
      return;
    }
    inviteListProcces.value = true;

    if (invitePage.value == 1) {
      invitelist.clear();
    }

    ProfileInviteListResponse response =
        await API.service.profileServices.invitelist(page: invitePage.value);

    if (!response.result.status) {
      log(response.result.description);

      inviteListProcces.value = false;
      isfirstfetch.value = false;

      return;
    }

    authroizedUserCount.value =
        response.result.descriptiondetail["dogrulanmishesap"];
    unauthroizedUserCount.value =
        response.result.descriptiondetail["normalhesap"];

    for (APIProfileInvitelist element in response.response!) {
      invitelist.add(
        ListTile(
          minVerticalPadding: 5.0,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          onTap: () {
            PageFunctions functions = PageFunctions();
            functions.pushProfilePage(
              Get.context!,
              User(
                userName: Rx<String>(element.username),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(element.avatar.minURL),
          ),
          // tileColor: ARMOYU.appbarColor,
          title: CustomText.costum1(element.displayName),
          subtitle: CustomText.costum1(element.username),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  element.isVerified == true
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.warning,
                          color: Colors.amber,
                        ),
                ],
              ),
              element.isVerified == false
                  ? IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Wrap(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[900],
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                          width: Get.width / 4,
                                          height: 5,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await sendmailURL(element.userID);
                                        },
                                        child: const ListTile(
                                          textColor: Colors.amber,
                                          leading: Icon(
                                            Icons.mail,
                                            color: Colors.amber,
                                          ),
                                          title: Text("Doğrulama gönder"),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert_rounded))
                  : Container(),
            ],
          ),
        ),
      );
    }

    invitePage.value++;
    inviteListProcces.value = false;
    isfirstfetch.value = false;
  }
}
