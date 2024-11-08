import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/app/functions/API_Functions/group.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PostdetailView(
                  //       postID: widget.categorydetailID,
                  //     ),
                  //   ),
                  // );

                  Get.toNamed("/social/detail", arguments: {
                    "postID": widget.categorydetailID,
                  });
                } else if (widget.categorydetail == "postyorum") {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PostdetailView(
                  //       commentID: widget.categorydetailID,
                  //     ),
                  //   ),
                  // );

                  Get.toNamed("/social/detail", arguments: {
                    "commentID": widget.categorydetailID,
                  });
                } else if (widget.category == "gruplar") {
                  Get.toNamed("/group/detail", arguments: {
                    'user': widget.currentUserAccounts.user,
                    'group': Group(groupID: widget.categorydetailID)
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => GroupPage(
                  //       currentUserAccounts: widget.currentUserAccounts,
                  //       groupID: widget.categorydetailID,
                  //     ),
                  //   ),
                  // );
                } else if (widget.category == "arkadaslik") {
                  if (widget.categorydetail == "kabul") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfilePage(
                    //       currentUserAccounts: widget.currentUserAccounts,
                    //       profileUser: User(userID: widget.user.userID),
                    //       ismyProfile: false,
                    //       scrollController: ScrollController(),
                    //     ),
                    //   ),
                    // );

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
                          currentUserAccounts: widget.currentUserAccounts);
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
                              widget.user.displayName!,
                              weight: FontWeight.bold,
                            ),
                            const Spacer(),
                            CustomText.costum1(widget.date),
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
                                text: "Kabul ET",
                                onPressed: () async {
                                  if (widget.category == "arkadaslik") {
                                    widget.natificationisVisible = false;
                                    widget.currentUserAccounts
                                        .friendRequestCount--;
                                    setstatefunction();

                                    if (widget.categorydetail == "istek") {
                                      FunctionsProfile f = FunctionsProfile(
                                        currentUser: widget
                                            .currentUserAccounts.user.value,
                                      );
                                      Map<String, dynamic> response =
                                          await f.friendrequestanswer(
                                              widget.user.userID!, 1);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        widget.natificationisVisible = true;
                                        widget.currentUserAccounts
                                            .friendRequestCount++;

                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  } else if (widget.category == "gruplar") {
                                    if (widget.categorydetail == "davet") {
                                      widget.currentUserAccounts
                                          .groupInviteCount--;
                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      FunctionsGroup f = FunctionsGroup(
                                        currentUser: widget
                                            .currentUserAccounts.user.value,
                                      );
                                      Map<String, dynamic> response =
                                          await f.grouprequestanswer(
                                              widget.categorydetailID, 1);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        widget.currentUserAccounts
                                            .groupInviteCount++;
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
                                text: "Reddet",
                                onPressed: () async {
                                  if (widget.category == "arkadaslik") {
                                    if (widget.categorydetail == "istek") {
                                      widget.currentUserAccounts
                                          .friendRequestCount--;
                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      FunctionsProfile f = FunctionsProfile(
                                        currentUser: widget
                                            .currentUserAccounts.user.value,
                                      );
                                      Map<String, dynamic> response =
                                          await f.friendrequestanswer(
                                              widget.user.userID!, 0);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        widget.currentUserAccounts
                                            .friendRequestCount++;
                                        widget.natificationisVisible = true;

                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  } else if (widget.category == "gruplar") {
                                    if (widget.categorydetail == "davet") {
                                      widget.currentUserAccounts
                                          .groupInviteCount--;
                                      widget.natificationisVisible = false;
                                      setstatefunction();
                                      FunctionsGroup f = FunctionsGroup(
                                        currentUser: widget
                                            .currentUserAccounts.user.value,
                                      );
                                      Map<String, dynamic> response =
                                          await f.grouprequestanswer(
                                              widget.categorydetailID, 0);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        widget.currentUserAccounts
                                            .groupInviteCount++;
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
