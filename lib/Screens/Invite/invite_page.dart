import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
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

  @override
  void initState() {
    super.initState();

    log("Davet Sayfası");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        // appBar: AppBar(
        //   title: const Text("Davet Et"),
        //   backgroundColor: ARMOYU.appbarColor,
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         // fetchnewscontent(widget.news.newsID);
        //       },
        //       icon: const Icon(Icons.refresh),
        //     ),
        //   ],
        // ),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Spacer(),
                        ARMOYU.Appuser.invitecode == null
                            ? InkWell(
                                onTap: () {
                                  log("asda");
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
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
