// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../functions/API_Functions/profile.dart';

class UserListWidget extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final int userID;
  final String profileImageUrl;
  final String username;
  final String displayname;
  bool isFriend;

  UserListWidget({
    super.key,
    required this.currentUserAccounts,
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.displayname,
    required this.isFriend,
  });

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  String buttonbefriend = "Arkadaş Ol";
  String buttonremovefriend = "Çıkar";
  @override
  void initState() {
    super.initState();
  }

  Future<void> friendrequest() async {
    FunctionsProfile f =
        FunctionsProfile(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.friendrequest(widget.userID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (mounted) {
      setState(() {
        buttonbefriend = "Gönderildi";
      });
    }
  }

  Future<void> removefriend() async {
    FunctionsProfile f =
        FunctionsProfile(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.friendremove(widget.userID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    widget.isFriend = false;
    if (mounted) {
      setState(() {
        buttonremovefriend = "Arkadaş Ol";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: GestureDetector(
            onTap: () {
              PageFunctions functions = PageFunctions(
                  currentUserAccounts: widget.currentUserAccounts);

              functions.pushProfilePage(
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
                  CachedNetworkImageProvider(widget.profileImageUrl),
              radius: 30,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Sola hizala
            children: [
              CustomText.costum1(widget.displayname, weight: FontWeight.bold),
              CustomText.costum1(widget.username),
            ],
          ),
        ),
        Visibility(
          visible: widget.isFriend &&
              widget.userID != widget.currentUserAccounts.user.userID,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButtons.costum1(
              text: buttonremovefriend,
              onPressed: removefriend,
              loadingStatus: false,
            ),
          ),
        ),
        Visibility(
          visible: !widget.isFriend &&
              widget.userID != widget.currentUserAccounts.user.userID,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButtons.costum1(
              text: buttonbefriend,
              onPressed: friendrequest,
              loadingStatus: false,
            ),
          ),
        )
      ],
    );
  }
}
