import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import '../detectabletext.dart';

// ignore: must_be_immutable
class CustomMenusNotificationbars {
  final UserAccounts currentUserAccounts;
  final User user;
  final String text;
  final String date;
  final String category;
  final String categorydetail;
  final int categorydetailID;
  final bool enableButtons;

  CustomMenusNotificationbars({
    required this.user,
    required this.currentUserAccounts,
    required this.text,
    required this.date,
    required this.category,
    required this.categorydetail,
    required this.categorydetailID,
    required this.enableButtons,
  });

  Widget notificationWidget(BuildContext context,
      {required Function deleteFunction}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              log(category.toString());
              log(categorydetail.toString());
              log(categorydetailID.toString());

              if (categorydetail == "post") {
                Get.toNamed("/social/detail", arguments: {
                  "postID": categorydetailID,
                });
              } else if (categorydetail == "postyorum") {
                Get.toNamed("/social/detail", arguments: {
                  "commentID": categorydetailID,
                });
              } else if (category == "gruplar") {
                Get.toNamed("/group/detail", arguments: {
                  'user': currentUserAccounts.user,
                  'group': Group(groupID: categorydetailID)
                });
              } else if (category == "arkadaslik") {
                if (categorydetail == "kabul") {
                  Get.to("/profile", arguments: {
                    "profileUser": User(userID: user.userID),
                  });
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    PageFunctions functions = PageFunctions();
                    functions.pushProfilePage(
                      context,
                      User(userID: user.userID),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage: CachedNetworkImageProvider(
                      user.avatar!.mediaURL.minURL.value,
                    ),
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText.costum1(
                            user.displayName!.value,
                            weight: FontWeight.bold,
                          ),
                          const Spacer(),
                          CustomText.costum1(date
                              .replaceAll('Saniye', CommonKeys.second.tr)
                              .replaceAll('Dakika', CommonKeys.minute.tr)
                              .replaceAll('Saat', CommonKeys.hour.tr)
                              .replaceAll('Gün', CommonKeys.day.tr)
                              .replaceAll('Ay', CommonKeys.month.tr)
                              .replaceAll('Yıl', CommonKeys.year.tr)),
                        ],
                      ),
                      CustomDedectabletext.costum1(text, 2, 15),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: enableButtons,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomButtons.costum1(
                              text: CommonKeys.accept.tr,
                              onPressed: () async {
                                if (category == "arkadaslik") {
                                  // natificationisVisible = false;
                                  deleteFunction();
                                  currentUserAccounts
                                          .friendRequestCount.value ==
                                      currentUserAccounts
                                              .friendRequestCount.value -
                                          1;

                                  if (categorydetail == "istek") {
                                    ServiceResult response = await API
                                        .service.profileServices
                                        .friendrequestanswer(
                                      userID: user.userID!,
                                      answer: 1,
                                    );
                                    if (!response.status) {
                                      ARMOYUWidget.toastNotification(
                                          response.description.toString());
                                      // natificationisVisible = true;
                                      deleteFunction();
                                      // currentUserAccounts
                                      //     .friendRequestCount++;
                                      currentUserAccounts.friendRequestCount
                                          .value = currentUserAccounts
                                              .friendRequestCount.value +
                                          1;
                                      1;

                                      return;
                                    }
                                  }
                                } else if (category == "gruplar") {
                                  if (categorydetail == "davet") {
                                    // currentUserAccounts
                                    //     .groupInviteCount--;

                                    currentUserAccounts.groupInviteCount.value =
                                        currentUserAccounts
                                                .groupInviteCount.value -
                                            1;

                                    // natificationisVisible = false;
                                    deleteFunction();

                                    GroupRequestAnswerResponse response =
                                        await API.service.groupServices
                                            .grouprequestanswer(
                                      groupID: categorydetailID,
                                      answer: "1",
                                    );
                                    if (!response.result.status) {
                                      ARMOYUWidget.toastNotification(response
                                          .result.description
                                          .toString());

                                      currentUserAccounts.groupInviteCount
                                          .value = currentUserAccounts
                                              .groupInviteCount.value +
                                          1;

                                      // natificationisVisible = true;
                                      deleteFunction();

                                      return;
                                    }
                                  }
                                }
                              },
                              loadingStatus: false.obs,
                            ),
                            const SizedBox(width: 16),
                            CustomButtons.costum1(
                              text: CommonKeys.decline.tr,
                              onPressed: () async {
                                if (category == "arkadaslik") {
                                  if (categorydetail == "istek") {
                                    // currentUserAccounts
                                    //     .friendRequestCount--;
                                    currentUserAccounts.friendRequestCount
                                        .value = currentUserAccounts
                                            .friendRequestCount.value -
                                        1;
                                    // natificationisVisible = false;
                                    deleteFunction();

                                    ServiceResult response = await API
                                        .service.profileServices
                                        .friendrequestanswer(
                                      userID: user.userID!,
                                      answer: 0,
                                    );
                                    if (!response.status) {
                                      ARMOYUWidget.toastNotification(
                                          response.description.toString());
                                      // currentUserAccounts
                                      //     .friendRequestCount++;

                                      currentUserAccounts.friendRequestCount
                                          .value = currentUserAccounts
                                              .friendRequestCount.value +
                                          1;

                                      // natificationisVisible = true;
                                      deleteFunction();

                                      return;
                                    }
                                  }
                                } else if (category == "gruplar") {
                                  if (categorydetail == "davet") {
                                    // currentUserAccounts
                                    //     .groupInviteCount--;

                                    currentUserAccounts.groupInviteCount.value =
                                        currentUserAccounts
                                                .groupInviteCount.value -
                                            1;
                                    // natificationisVisible = false;
                                    deleteFunction();

                                    GroupRequestAnswerResponse response =
                                        await API.service.groupServices
                                            .grouprequestanswer(
                                      groupID: categorydetailID,
                                      answer: "0",
                                    );
                                    if (!response.result.status) {
                                      ARMOYUWidget.toastNotification(response
                                          .result.description
                                          .toString());
                                      // currentUserAccounts
                                      //     .groupInviteCount++;

                                      currentUserAccounts.groupInviteCount
                                          .value = currentUserAccounts
                                              .groupInviteCount.value +
                                          1;
                                      // natificationisVisible = true;
                                      deleteFunction();

                                      return;
                                    }
                                  }
                                }
                              },
                              loadingStatus: false.obs,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
