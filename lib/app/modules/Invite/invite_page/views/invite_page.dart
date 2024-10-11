import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvitePage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  const InvitePage({
    super.key,
    required this.currentUserAccounts,
  });
  @override
  State<InvitePage> createState() => _EventStatePage();
}

bool isfirstfetch = true;
bool newsfetchProcess = false;
int authroizedUserCount = 0;
int unauthroizedUserCount = 0;
List<Widget> invitelist = [];
int invitePage = 1;
bool inviteListProcces = false;

final ScrollController _scrollController = ScrollController();
bool shouldShowTitle = true;

class _EventStatePage extends State<InvitePage>
    with AutomaticKeepAliveClientMixin<InvitePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    log("Davet Sayfası");

    if (isfirstfetch) {
      invitepeoplelist();
    }

    _scrollController.addListener(() {
      if (_scrollController.offset > (ARMOYU.screenHeight * 0.25 / 2)) {
        if (mounted) {
          setState(() {
            shouldShowTitle = false; // Başlık görünürlüğünü false yap
          });
        }
      } else {
        if (mounted) {
          setState(() {
            shouldShowTitle = true; // Başlık görünürlüğünü true yap
          });
        }
      }
    });
  }

  Future<void> sendmailURL(int userID) async {
    FunctionsProfile f =
        FunctionsProfile(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.sendauthmailURL(userID);
    log(response["durum"].toString());
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (mounted) {
      ARMOYUWidget.stackbarNotification(context, response["aciklama"]);
    }
  }

  Future<void> invitepeoplelist() async {
    if (inviteListProcces == true) {
      return;
    }
    setState(() {
      inviteListProcces = true;
    });

    if (invitePage == 1) {
      invitelist.clear();
    }
    FunctionsProfile f =
        FunctionsProfile(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.invitelist(invitePage);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      setState(() {
        inviteListProcces = false;
        isfirstfetch = false;
      });
      return;
    }

    authroizedUserCount = response["aciklamadetay"]["dogrulanmishesap"];
    unauthroizedUserCount = response["aciklamadetay"]["normalhesap"];

    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          invitelist.add(
            ListTile(
              minVerticalPadding: 5.0,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              onTap: () {
                PageFunctions functions = PageFunctions(
                    currentUserAccounts: widget.currentUserAccounts);
                functions.pushProfilePage(
                  context,
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
              title: CustomText.costum1(
                  response["icerik"][i]["oyuncu_displayname"]),
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
                            if (mounted) {
                              showModalBottomSheet<void>(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                width: ARMOYU.screenWidth / 4,
                                                height: 5,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await sendmailURL(
                                                    response["icerik"][i]
                                                        ["oyuncu_ID"]);
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
                            }
                          },
                          icon: const Icon(Icons.more_vert_rounded))
                      : Container(),
                ],
              ),
            ),
          );
        });
      }
    }

    invitePage++;
    if (mounted) {
      setState(() {
        inviteListProcces = false;
        isfirstfetch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Future<void> refreshInviteCode() async {
      FunctionsProfile f =
          FunctionsProfile(currentUser: widget.currentUserAccounts.user);
      Map<String, dynamic> response = await f.invitecoderefresh();

      if (response["durum"] == 0) {
        log(response["aciklama"]);
        return;
      }
      setState(() {
        widget.currentUserAccounts.user.invitecode = response["aciklamadetay"];
      });
    }

    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            leading: const BackButton(
              color: Colors.white,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () async {
                  // await refreshInviteCode();
                  invitePage = 1;
                  await invitepeoplelist();
                },
              )
            ],
            pinned: true,
            backgroundColor: ARMOYU.backgroundcolor,
            expandedHeight: ARMOYU.screenHeight * 0.25,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl:
                    "https://img.freepik.com/premium-photo/abstract-background-modern-office-building-exterior-new-business-district_31965-133971.jpg",
                fit: BoxFit.cover,
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 00.0),
              title: Stack(
                children: [
                  Wrap(
                    children: [
                      Column(
                        children: [
                          Visibility(
                            visible: shouldShowTitle,
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: CachedNetworkImageProvider(
                                  widget.currentUserAccounts.user.avatar!
                                      .mediaURL.normalURL,
                                ),
                                radius: 25,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: shouldShowTitle,
                            child: const SizedBox(height: 10),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () async =>
                                        await refreshInviteCode(),
                                    child: const Icon(
                                      color: Colors.white,
                                      Icons.refresh,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: widget.currentUserAccounts.user
                                              .invitecode!
                                              .toString(),
                                        ),
                                      );
                                      ARMOYUWidget.toastNotification(
                                          "Kod koyalandı");
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.currentUserAccounts.user
                                              .invitecode
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !shouldShowTitle,
                            child: const SizedBox(height: 20),
                          ),
                          Visibility(
                            visible: shouldShowTitle,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.amber,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "Normal Hesap : ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        unauthroizedUserCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "Doğrulanmış Hesap : ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        authroizedUserCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              invitePage = 1;
              await invitepeoplelist();
            },
          ),
          SliverToBoxAdapter(
            child: invitelist.isEmpty
                ? Center(
                    child: !isfirstfetch && !inviteListProcces
                        ? const Text("Henüz kimse davet edilmemiş")
                        : const CupertinoActivityIndicator(),
                  )
                : Column(
                    children: List.generate(
                      invitelist.length,
                      (index) => invitelist[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
