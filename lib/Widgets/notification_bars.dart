// ignore_for_file: must_be_immutable

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/group.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'detectabletext.dart';

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

bool natificationisVisible = true;

class _CustomMenusNotificationbarsState
    extends State<CustomMenusNotificationbars> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: natificationisVisible,
      child: InkWell(
        onTap: () {
          log("tıklanabilir içerik");
        },
        child: Container(
          color: ARMOYU.appbarColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(userID: widget.userID, appbar: true),
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          foregroundImage:
                              CachedNetworkImageProvider(widget.avatar),
                          radius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.displayname,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        CustomDedectabletext.costum1(widget.text, 1, 15),
                        Visibility(
                          visible: widget.enableButtons,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (widget.category == "arkadaslik") {
                                    if (widget.categorydetail == "istek") {
                                      FunctionsProfile f = FunctionsProfile();
                                      Map<String, dynamic> response =
                                          await f.friendrequestanswer(
                                              widget.userID, 1);
                                      if (response["durum"] == 0) {
                                        log(response["aciklama"]);
                                        return;
                                      }
                                      setState(() {
                                        natificationisVisible = false;
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
                                      setState(() {
                                        natificationisVisible = false;
                                      });
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: CustomText.costum1("Kabul ET"),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  if (widget.category == "arkadaslik") {
                                    if (widget.categorydetail == "istek") {
                                      FunctionsProfile f = FunctionsProfile();
                                      Map<String, dynamic> response =
                                          await f.friendrequestanswer(
                                              widget.userID, 0);
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
                                    natificationisVisible = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: CustomText.costum1("Reddet"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
