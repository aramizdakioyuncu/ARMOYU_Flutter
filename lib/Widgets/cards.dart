import 'dart:developer';

import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Widgets/Skeletons/cards_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCards extends StatefulWidget {
  final String title;
  final List<Map<String, String>> content;
  final Icon icon;
  final Color effectcolor;
  final ScrollController scrollController;
  final bool firstFetch;

  const CustomCards({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.effectcolor,
    required this.scrollController,
    required this.firstFetch,
  });

  @override
  State<CustomCards> createState() => _CustomCardsState();
}

class _CustomCardsState extends State<CustomCards> {
  bool morefetchProcces = false;
  bool firstFetchProcces = false;

  @override
  void initState() {
    super.initState();

    if (!firstFetchProcces && widget.firstFetch) {
      morefetchinfo();
      firstFetchProcces = true;
    }
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        morefetchinfo();
      }
    });
  }

  int asa(int length) {
    return (length ~/ 10) + 1;
  }

  Future<void> morefetchinfo() async {
    if (morefetchProcces) {
      return;
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = {};

    if (widget.title == "POP") {
      response = await f.getplayerpop(
          int.parse(((widget.content.length ~/ 10) + 1).toString()));
    } else {
      response = await f.getplayerxp(
          int.parse(((widget.content.length ~/ 10) + 1).toString()));
    }
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          if (widget.title == "POP") {
            widget.content.add({
              "userID": response["icerik"][i]["oyuncuID"].toString(),
              "image": response["icerik"][i]["oyuncuavatar"],
              "displayname": response["icerik"][i]["oyuncuadsoyad"],
              "score": response["icerik"][i]["oyuncupop"].toString()
            });
          } else {
            widget.content.add({
              "userID": response["icerik"][i]["oyuncuID"].toString(),
              "image": response["icerik"][i]["oyuncuavatar"],
              "displayname": response["icerik"][i]["oyuncuadsoyad"],
              "score":
                  response["icerik"][i]["oyuncuseviyesezonlukxp"].toString()
            });
          }
        });
      }
    }
    log(((widget.content.length ~/ 10)).toString());

    morefetchProcces = false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.content.isEmpty
        ? SkeletonCustomCards(count: 5, icon: widget.icon)
        : SizedBox(
            height: 220,
            child: ListView.separated(
              controller: widget.scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              scrollDirection: Axis.horizontal,
              itemCount: widget.content.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final cardData = widget.content[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          appbar: true,
                          userID: int.parse(cardData["userID"].toString()),
                          scrollController: ScrollController(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        image: CachedNetworkImageProvider(
                          cardData["image"]!,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            widget.effectcolor,
                            Colors.transparent,
                            Colors.black,
                          ],
                          stops: const [0.1, 0.8, 1],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                          // alignment: Alignment.bottomCenter,
                          children: [
                            const SizedBox(
                              height: 0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      cardData["displayname"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        widget.icon,
                                        const SizedBox(width: 5),
                                        Text(
                                          cardData["score"].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 20),
            ),
          );
  }
}
