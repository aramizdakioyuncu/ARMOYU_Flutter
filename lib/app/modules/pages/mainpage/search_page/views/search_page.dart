import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';

import 'package:ARMOYU/app/modules/pages/mainpage/search_page/controllers/search_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final bool appbar;
  final ScrollController scrollController;
  const SearchPage({
    super.key,
    required this.currentUserAccounts,
    required this.appbar,
    required this.scrollController,
  });

  @override
  State<SearchPage> createState() => _SearchPagePage();
}

class _SearchPagePage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final currentAccountController = Get.find<AppPageController>();
    final currentAccountController = Get.find<PagesController>(
      tag: widget.currentUserAccounts.user.userID.toString(),
    );
    log("*****${currentAccountController.currentUserAccounts.user.displayName}");

    final mainpagecontroller = Get.find<MainPageController>(
      tag: widget.currentUserAccounts.user.userID.toString(),
    );

    final controller = Get.put(
      SearchPageController(
        currentUserAccounts: currentAccountController.currentUserAccounts,
        searchController: mainpagecontroller.appbarSearchTextController.value,
      ),
      tag: widget.currentUserAccounts.user.userID.toString(),
    );

    return Scaffold(
      body: Obx(
        () => controller.widgetSearch.isNotEmpty
            ? ListView.builder(
                controller: ScrollController(),
                itemCount: controller.widgetSearch.length,
                itemBuilder: (context, index) {
                  return controller.widgetSearch[index];
                },
              )
            : SingleChildScrollView(
                controller: mainpagecontroller.searchScrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        enableInfiniteScroll: true,
                        pauseAutoPlayOnTouch: true,
                        viewportFraction: 0.8,
                        autoPlayInterval: const Duration(seconds: 5),
                        scrollDirection: Axis.horizontal,
                        enlargeFactor: 0.2,
                        enlargeCenterPage: true,
                      ),
                      itemCount: controller.newsList.length,
                      itemBuilder: (context, index, realIndex) {
                        return controller.newsList.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => NewsPage(
                                  //       currentUser:
                                  //           widget.currentUserAccounts.user,
                                  //       news: newsList[index],
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      image: CachedNetworkImageProvider(
                                        controller.newsList[index].newsImage,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.8],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            7, 0, 7, 7),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    controller.newsList[index]
                                                        .authoravatar,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  controller
                                                      .newsList[index].author,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons.visibility),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      controller.newsList[index]
                                                          .newsViews
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              controller
                                                  .newsList[index].newssummary,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: ARMOYU.screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // color: ARMOYU.appbarColor,
                                ),
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                      },
                    ),
                    const SizedBox(height: 10),
                    controller.widgetTPCard.value!,
                    const SizedBox(height: 10),
                    controller.widgetPOPCard.value!,
                  ],
                ),
              ),
      ),
    );
  }
}
