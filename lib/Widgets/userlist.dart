// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, must_be_immutable

import 'dart:developer';

import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Functions/API_Functions/profile.dart';

class UserListWidget extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final String displayname;
  bool isFriend;

  UserListWidget({
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
    FunctionsProfile f = FunctionsProfile();
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
    FunctionsProfile f = FunctionsProfile();
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(userID: widget.userID, appbar: true)));
            },
            child: CircleAvatar(
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
              CustomText().Costum1(widget.displayname, weight: FontWeight.bold),
              CustomText().Costum1(widget.username),
            ],
          ),
        ),
        Visibility(
          visible: widget.isFriend,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButtons()
                .Costum1(buttonremovefriend, removefriend, false),
          ),
        ),
        Visibility(
          visible: !widget.isFriend,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                CustomButtons().Costum1(buttonbefriend, friendrequest, false),
          ),
        )
      ],
    );
  }
}