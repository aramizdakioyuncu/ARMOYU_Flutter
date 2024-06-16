// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/page_functions.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Group/group_page.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/Social/postdetail_page.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Functions/API_Functions/group.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'detectabletext.dart';

class CustomMenusNotificationbars extends StatefulWidget {
  final User? currentUser;
  final int userID;
  final String displayname;
  final String avatar;
  final String text;
  final String date;
  final String category;
  final String categorydetail;
  final int categorydetailID;
  final bool enableButtons;
  bool natificationisVisible = true;

  CustomMenusNotificationbars({
    super.key,
    required this.currentUser,
    required this.userID,
    required this.displayname,
    required this.avatar,
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
        color: ARMOYU.appbarColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                log(widget.category.toString());
                log(widget.categorydetail.toString());
                log(widget.categorydetailID.toString());

                if (widget.categorydetail == "post") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                        postID: widget.categorydetailID,
                      ),
                    ),
                  );
                } else if (widget.categorydetail == "postyorum") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                        commentID: widget.categorydetailID,
                      ),
                    ),
                  );
                } else if (widget.category == "gruplar") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupPage(
                        currentUser: widget.currentUser,
                        groupID: widget.categorydetailID,
                      ),
                    ),
                  );
                } else if (widget.category == "arkadaslik") {
                  if (widget.categorydetail == "kabul") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          ismyProfile: false,
                          currentUser: User(userID: widget.userID),
                          scrollController: ScrollController(),
                        ),
                      ),
                    );
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      PageFunctions.pushProfilePage(
                        context,
                        User(
                          userID: widget.userID,
                        ),
                        ScrollController(),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          CachedNetworkImageProvider(widget.avatar),
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
                              widget.displayname,
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
                                    ARMOYU.friendRequestCount--;
                                    setstatefunction();

                                    if (widget.categorydetail == "istek") {
                                      FunctionsProfile f = FunctionsProfile();
                                      Map<String, dynamic> response =
                                          await f.friendrequestanswer(
                                              widget.userID, 1);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        widget.natificationisVisible = true;
                                        ARMOYU.friendRequestCount++;

                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  } else if (widget.category == "gruplar") {
                                    if (widget.categorydetail == "davet") {
                                      ARMOYU.groupInviteCount--;
                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      FunctionsGroup f = FunctionsGroup();
                                      Map<String, dynamic> response =
                                          await f.grouprequestanswer(
                                              widget.categorydetailID, 1);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        ARMOYU.groupInviteCount++;
                                        widget.natificationisVisible = true;
                                        setstatefunction();

                                        return;
                                      }
                                    }
                                  }
                                },
                                loadingStatus: false,
                              ),
                              const SizedBox(width: 16),
                              CustomButtons.costum1(
                                text: "Reddet",
                                onPressed: () async {
                                  if (widget.category == "arkadaslik") {
                                    if (widget.categorydetail == "istek") {
                                      ARMOYU.friendRequestCount--;
                                      widget.natificationisVisible = false;
                                      setstatefunction();

                                      FunctionsProfile f = FunctionsProfile();
                                      Map<String, dynamic> response =
                                          await f.friendrequestanswer(
                                              widget.userID, 0);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        ARMOYU.friendRequestCount++;
                                        widget.natificationisVisible = true;

                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  } else if (widget.category == "gruplar") {
                                    if (widget.categorydetail == "davet") {
                                      ARMOYU.groupInviteCount--;
                                      widget.natificationisVisible = false;
                                      setstatefunction();
                                      FunctionsGroup f = FunctionsGroup();
                                      Map<String, dynamic> response =
                                          await f.grouprequestanswer(
                                              widget.categorydetailID, 0);
                                      if (response["durum"] == 0) {
                                        ARMOYUWidget.toastNotification(
                                            response["aciklama"].toString());
                                        ARMOYU.groupInviteCount++;
                                        widget.natificationisVisible = true;

                                        setstatefunction();
                                        return;
                                      }
                                    }
                                  }
                                },
                                loadingStatus: false,
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
