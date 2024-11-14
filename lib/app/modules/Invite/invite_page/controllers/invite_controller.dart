import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/text.dart';
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
    FunctionsProfile f =
        FunctionsProfile(currentUser: currentUserAccounts.value!.user.value);
    Map<String, dynamic> response = await f.invitecoderefresh();

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    currentUserAccounts.value!.user.value.invitecode =
        Rx<String>(response["aciklamadetay"]);

    currentUserAccounts.value!.user.refresh();
  }

  Future<void> sendmailURL(int userID) async {
    FunctionsProfile f =
        FunctionsProfile(currentUser: currentUserAccounts.value!.user.value);
    Map<String, dynamic> response = await f.sendauthmailURL(userID);
    log(response["durum"].toString());
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    ARMOYUWidget.stackbarNotification(Get.context!, response["aciklama"]);
  }

  Future<void> invitepeoplelist() async {
    if (inviteListProcces.value == true) {
      return;
    }
    inviteListProcces.value = true;

    if (invitePage.value == 1) {
      invitelist.clear();
    }
    FunctionsProfile f =
        FunctionsProfile(currentUser: currentUserAccounts.value!.user.value);
    Map<String, dynamic> response = await f.invitelist(invitePage.value);

    if (response["durum"] == 0) {
      log(response["aciklama"]);

      inviteListProcces.value = false;
      isfirstfetch.value = false;

      return;
    }

    authroizedUserCount.value = response["aciklamadetay"]["dogrulanmishesap"];
    unauthroizedUserCount.value = response["aciklamadetay"]["normalhesap"];

    for (int i = 0; i < response["icerik"].length; i++) {
      invitelist.add(
        ListTile(
          minVerticalPadding: 5.0,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          onTap: () {
            PageFunctions functions = PageFunctions(
              currentUser: currentUserAccounts.value!.user.value,
            );
            functions.pushProfilePage(
              Get.context!,
              User(
                userName: response["icerik"][i]["oyuncu_username"],
              ),
              ScrollController(),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(
              response["icerik"][i]["oyuncu_avatar"],
            ),
          ),
          // tileColor: ARMOYU.appbarColor,
          title:
              CustomText.costum1(response["icerik"][i]["oyuncu_displayname"]),
          subtitle:
              CustomText.costum1(response["icerik"][i]["oyuncu_username"]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  response["icerik"][i]["oyuncu_dogrulama"] == true
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
              response["icerik"][i]["oyuncu_dogrulama"] == false
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
                                          await sendmailURL(response["icerik"]
                                              [i]["oyuncu_ID"]);
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
