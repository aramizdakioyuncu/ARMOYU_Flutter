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
import 'detectabletext.dart';

// ignore: must_be_immutable
class CustomMenusNotificationbars extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final User user;
  final String text;
  final String date;
  final String category;
  final String categorydetail;
  final int categorydetailID;
  final bool enableButtons;
  bool natificationisVisible = true;

  CustomMenusNotificationbars({
    super.key,
    required this.user,
    required this.currentUserAccounts,
    required this.text,
    required this.date,
    required this.category,
    required this.categorydetail,
    required this.categorydetailID,
    required this.enableButtons,
  });

  @override
  State<CustomMenusNotificationbars> createState() =>
      _CustomMenusNotificationbarsState();
}

class _CustomMenusNotificationbarsState
    extends State<CustomMenusNotificationbars> {
  @override
  void initState() {
    super.initState();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.natificationisVisible,
      child: Container(
        // color: ARMOYU.appbarColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                log(widget.category.toString());
                log(widget.categorydetail.toString());
                log(widget.categorydetailID.toString());

                if (widget.categorydetail == "post") {
                  Get.toNamed("/social/detail", arguments: {
                    "postID": widget.categorydetailID,
                  });
                } else if (widget.categorydetail == "postyorum") {
                  Get.toNamed("/social/detail", arguments: {
                    "commentID": widget.categorydetailID,
                  });
                } else if (widget.category == "gruplar") {
                  Get.toNamed("/group/detail", arguments: {
                    'user': widget.currentUserAccounts.user,
                    'group': Group(groupID: widget.categorydetailID)
                  });
                } else if (widget.category == "arkadaslik") {
                  if (widget.categorydetail == "kabul") {
                    Get.to("/profile", arguments: {
                      "profileUser": User(userID: widget.user.userID),
                    });
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      PageFunctions functions = PageFunctions(
                        currentUser: widget.currentUserAccounts.user.value,
                      );
                      functions.pushProfilePage(
                        context,
                        User(
                          userID: widget.user.userID,
                        ),
                        ScrollController(),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(
                        widget.user.avatar!.mediaURL.minURL.value,
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
                              widget.user.displayName!.value,
                              weight: FontWeight.bold,
                            ),
                            const Spacer(),
                            CustomText.costum1(widget.date
                                .replaceAll('Saniye', CommonKeys.second.tr)
                                .replaceAll('Dakika', CommonKeys.minute.tr)
                                .replaceAll('Saat', CommonKeys.hour.tr)
                                .replaceAll('Gün', CommonKeys.day.tr)
                                .replaceAll('Ay', CommonKeys.month.tr)
                                .replaceAll('Yıl', CommonKeys.year.tr)),
                          ],
                        ),
                        CustomDedectabletext.costum1(widget.text, 2, 15),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: widget.enableButtons,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomButtons.costum1(
                                text: CommonKeys.accept.tr,
                                onPressed: () async {
                                  if (widget.category == "arkadaslik") {
                                    widget.natificationisVisible = false;
                                    widget.currentUserAccounts
                                            .friendRequestCount.value ==
                                        widget.currentUserAccounts
                                                .friendRequestCount.value -
                                            1;

                                    setstatefunction();

                                    if (widget.categorydetail == "istek") {
                                      ServiceResult response = await API
                                          .service.profileServices
                                          .friendrequestanswer(
                                        userID: widget.user.userID!,
                                        answer: 1,
                                      );
                                      if (!response.status) {
                                        ARMOYUWidget.toastNotification(
                                            response.description.toString());
                                        widget.natificationisVisible = true;
                                        // widget.currentUserAccounts
                                        //     .friendRequestCount++;
                                        widget.currentUserAccounts
                                            .friendRequestCount.value = widget
                                                .currentUserAccounts
                                                .friendRequestCount
                                                .value +
                                            1;
                                        1;
                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  } else if (widget.category == "gruplar") {
                                    if (widget.categorydetail == "davet") {
                                      // widget.currentUserAccounts
                                      //     .groupInviteCount--;

                                      widget.currentUserAccounts
                                          .groupInviteCount.value = widget
                                              .currentUserAccounts
                                              .groupInviteCount
                                              .value -
                                          1;

                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      GroupRequestAnswerResponse response =
                                          await API.service.groupServices
                                              .grouprequestanswer(
                                        groupID: widget.categorydetailID,
                                        answer: "1",
                                      );
                                      if (!response.result.status) {
                                        ARMOYUWidget.toastNotification(response
                                            .result.description
                                            .toString());

                                        widget.currentUserAccounts
                                            .groupInviteCount.value = widget
                                                .currentUserAccounts
                                                .groupInviteCount
                                                .value +
                                            1;

                                        widget.natificationisVisible = true;
                                        setstatefunction();

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
                                  if (widget.category == "arkadaslik") {
                                    if (widget.categorydetail == "istek") {
                                      // widget.currentUserAccounts
                                      //     .friendRequestCount--;
                                      widget.currentUserAccounts
                                          .friendRequestCount.value = widget
                                              .currentUserAccounts
                                              .friendRequestCount
                                              .value -
                                          1;
                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      ServiceResult response = await API
                                          .service.profileServices
                                          .friendrequestanswer(
                                        userID: widget.user.userID!,
                                        answer: 0,
                                      );
                                      if (!response.status) {
                                        ARMOYUWidget.toastNotification(
                                            response.description.toString());
                                        // widget.currentUserAccounts
                                        //     .friendRequestCount++;

                                        widget.currentUserAccounts
                                            .friendRequestCount.value = widget
                                                .currentUserAccounts
                                                .friendRequestCount
                                                .value +
                                            1;

                                        widget.natificationisVisible = true;

                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  } else if (widget.category == "gruplar") {
                                    if (widget.categorydetail == "davet") {
                                      // widget.currentUserAccounts
                                      //     .groupInviteCount--;

                                      widget.currentUserAccounts
                                          .groupInviteCount.value = widget
                                              .currentUserAccounts
                                              .groupInviteCount
                                              .value -
                                          1;
                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      GroupRequestAnswerResponse response =
                                          await API.service.groupServices
                                              .grouprequestanswer(
                                        groupID: widget.categorydetailID,
                                        answer: "0",
                                      );
                                      if (!response.result.status) {
                                        ARMOYUWidget.toastNotification(response
                                            .result.description
                                            .toString());
                                        // widget.currentUserAccounts
                                        //     .groupInviteCount++;

                                        widget.currentUserAccounts
                                            .groupInviteCount.value = widget
                                                .currentUserAccounts
                                                .groupInviteCount
                                                .value +
                                            1;
                                        widget.natificationisVisible = true;

                                        setstatefunction();
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
      ),
    );
  }
}
