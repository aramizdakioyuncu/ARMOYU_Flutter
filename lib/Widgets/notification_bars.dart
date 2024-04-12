import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/group.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'detectabletext.dart';

// ignore: must_be_immutable
class CustomMenusNotificationbars extends StatefulWidget {
  int userID;
  String displayname;
  String avatar;
  String text;
  String date;
  String category;
  String categorydetail;
  int categorydetailID;
  bool enableButtons;
  bool natificationisVisible = true;

  CustomMenusNotificationbars({
    super.key,
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
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.natificationisVisible,
      child: Container(
        color: ARMOYU.appbarColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(userID: widget.userID, appbar: true),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage: CachedNetworkImageProvider(widget.avatar),
                    radius: 30,
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
                            CustomButtons.costum1("Kabul ET",
                                onPressed: () async {
                              if (widget.category == "arkadaslik") {
                                if (widget.categorydetail == "istek") {
                                  FunctionsProfile f = FunctionsProfile();
                                  Map<String, dynamic> response = await f
                                      .friendrequestanswer(widget.userID, 1);
                                  if (response["durum"] == 0) {
                                    log(response["aciklama"]);
                                    return;
                                  }

                                  ARMOYU.friendRequestCount--;
                                  setState(() {
                                    widget.natificationisVisible = false;
                                  });
                                }
                              } else if (widget.category == "gruplar") {
                                if (widget.categorydetail == "davet") {
                                  FunctionsGroup f = FunctionsGroup();
                                  Map<String, dynamic> response =
                                      await f.grouprequestanswer(
                                          widget.categorydetailID, 1);
                                  if (response["durum"] == 0) {
                                    log(response["aciklama"]);
                                    return;
                                  }
                                  ARMOYU.groupInviteCount--;

                                  setState(() {
                                    widget.natificationisVisible = false;
                                  });
                                }
                              }
                            }, loadingStatus: false),
                            const SizedBox(width: 16),
                            CustomButtons.costum1("Reddet",
                                onPressed: () async {
                              if (widget.category == "arkadaslik") {
                                if (widget.categorydetail == "istek") {
                                  FunctionsProfile f = FunctionsProfile();
                                  Map<String, dynamic> response = await f
                                      .friendrequestanswer(widget.userID, 0);
                                  if (response["durum"] == 0) {
                                    log(response["aciklama"]);
                                  }
                                }
                              } else if (widget.category == "gruplar") {
                                if (widget.categorydetail == "davet") {
                                  FunctionsGroup f = FunctionsGroup();
                                  Map<String, dynamic> response =
                                      await f.grouprequestanswer(
                                          widget.categorydetailID, 0);
                                  if (response["durum"] == 0) {
                                    log(response["aciklama"]);
                                  }
                                }
                              }
                              setState(() {
                                widget.natificationisVisible = false;
                              });
                            }, loadingStatus: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
