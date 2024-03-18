import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletons/skeletons.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({
    super.key,
  });
  @override
  State<InvitePage> createState() => _EventStatePage();
}

bool isfirstfetch = true;
bool newsfetchProcess = false;

class _EventStatePage extends State<InvitePage>
    with AutomaticKeepAliveClientMixin<InvitePage> {
  @override
  bool get wantKeepAlive => true;

  List<Widget> invitelist = [
    ListTile(
      minVerticalPadding: 5.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      tileColor: ARMOYU.appbarColor,
      leading: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      title: const SkeletonLine(),
      subtitle: const SkeletonLine(
        style: SkeletonLineStyle(width: 50),
      ),
    ),
    ListTile(
      minVerticalPadding: 5.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      tileColor: ARMOYU.appbarColor,
      leading: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      title: const SkeletonLine(),
      subtitle: const SkeletonLine(
        style: SkeletonLineStyle(width: 50),
      ),
    ),
    ListTile(
      minVerticalPadding: 5.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      tileColor: ARMOYU.appbarColor,
      leading: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      title: const SkeletonLine(),
      subtitle: const SkeletonLine(
        style: SkeletonLineStyle(width: 50),
      ),
    )
  ];

  @override
  void initState() {
    super.initState();

    log("Davet Sayfası");
    invitepeoplelist();
  }

  Future<void> invitepeoplelist() async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.invitelist(1);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    log(response.toString());
    invitelist.clear();

    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          invitelist.add(
            ListTile(
              minVerticalPadding: 5.0,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              leading: CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(
                  response["icerik"][i]["oyuncu_avatar"],
                ),
              ),
              tileColor: ARMOYU.appbarColor,
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
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
                                            onTap: () async {},
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      "https://img.freepik.com/premium-photo/abstract-background-modern-office-building-exterior-new-business-district_31965-133971.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_sharp),
                          color: Colors.white,
                          onPressed: () {
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                          ARMOYU.Appuser.avatar!.mediaURL.normalURL),
                      radius: 40,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Spacer(),
                        ARMOYU.Appuser.invitecode == null
                            ? InkWell(
                                onTap: () async {
                                  FunctionsProfile f = FunctionsProfile();
                                  Map<String, dynamic> response =
                                      await f.invitecoderefresh();

                                  if (response["durum"] == 0) {
                                    log(response["aciklama"]);
                                    return;
                                  }
                                  setState(() {
                                    ARMOYU.Appuser.invitecode =
                                        response["aciklamadetay"];
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        InkWell(child: Icon(Icons.refresh))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                        text: ARMOYU.Appuser.invitecode!
                                            .toString()),
                                  );
                                  Fluttertoast.showToast(
                                    msg: "Kod kopyalandı",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ARMOYU.bodyColor,
                                    textColor: ARMOYU.color,
                                    fontSize: 14.0,
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          ARMOYU.Appuser.invitecode.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26),
                                        ),
                                        const Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.amber,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Normal Hesap : ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Doğrulanmış Hesap : ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {},
                child: ListView.builder(
                  itemCount: invitelist.length,
                  itemBuilder: (context, index) {
                    return invitelist[index];
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
