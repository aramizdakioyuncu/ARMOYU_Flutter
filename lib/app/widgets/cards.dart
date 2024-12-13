import 'dart:developer';

import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/Skeletons/cards_skeleton.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCards extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final String title;
  final List<Map<String, String>> content;
  final Icon icon;
  final Color effectcolor;
  final ScrollController scrollController;
  final bool firstFetch;

  const CustomCards({
    super.key,
    required this.currentUserAccounts,
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
      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent * 0.8) {
        morefetchinfo();
      }
    });
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> morefetchinfo() async {
    if (morefetchProcces) {
      return;
    }
    morefetchProcces = true;
    setstatefunction();
    FunctionService f = FunctionService();

    if (widget.title == "POP") {
      PlayerPopResponse response = await f.getplayerpop(
          int.parse(((widget.content.length ~/ 10) + 1).toString()));

      if (!response.result.status) {
        log(response.result.description);
        morefetchProcces = false;
        setstatefunction();
        return;
      }

      for (APIPlayerPop element in response.response!) {
        widget.content.add({
          "userID": element.oyuncuID.toString(),
          "image": element.oyuncuAvatar,
          "displayname": element.oyuncuAdSoyad,
          "score": element.oyuncuPop.toString()
        });
      }
    } else {
      PlayerPopResponse response = await f.getplayerxp(
          int.parse(((widget.content.length ~/ 10) + 1).toString()));

      if (!response.result.status) {
        log(response.result.description);
        morefetchProcces = false;
        setstatefunction();
        return;
      }

      for (APIPlayerPop element in response.response!) {
        widget.content.add({
          "userID": element.oyuncuID.toString(),
          "image": element.oyuncuAvatar,
          "displayname": element.oyuncuAdSoyad,
          "score": element.oyuncuSeviyeSezonlukXP.toString()
        });
      }
    }

    log(((widget.content.length ~/ 10)).toString());

    morefetchProcces = false;
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content.isEmpty) {
      return SkeletonCustomCards(count: 5, icon: widget.icon);
    }
    return SizedBox(
      height: 220,
      child: ListView.separated(
        controller: widget.scrollController,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        scrollDirection: Axis.horizontal,
        itemCount: morefetchProcces
            ? widget.content.length + 1
            : widget.content.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (widget.content.length == index) {
            return const SizedBox(
              width: 150,
              child: CupertinoActivityIndicator(),
            );
          }

          final cardData = widget.content[index];
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              PageFunctions functions = PageFunctions(
                currentUser: widget.currentUserAccounts.user.value,
              );
              functions.pushProfilePage(
                context,
                User(
                  userID: int.parse(cardData["userID"].toString()),
                ),
                ScrollController(),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
      ),
    );
  }
}
