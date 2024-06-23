import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/notification_bars.dart';

class NotificationFriendRequestPage extends StatefulWidget {
  final User currentUser;

  const NotificationFriendRequestPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<NotificationFriendRequestPage> createState() => _NotificationPage();
}

bool _pageproccess = false;
int _page = 1;
bool _firstFetchProcces = true;
List<CustomMenusNotificationbars> widgetNotifications = [];

final ScrollController _scrollController = ScrollController();

class _NotificationPage extends State<NotificationFriendRequestPage>
    with AutomaticKeepAliveClientMixin<NotificationFriendRequestPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    if (_firstFetchProcces) {
      loadnoifications();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });
  }

  void setstatefunction() {
    if (mounted) {
      setstatefunction();
    }
  }

  Future<void> _loadMoreData() async {
    if (!_pageproccess) {
      await loadnoifications();
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _page = 1;
      loadnoifications();
    });
  }

  Future<void> loadnoifications() async {
    if (_pageproccess) {
      return;
    }
    setState(() {
      _pageproccess = true;
    });

    FunctionService f = FunctionService(currentUser: widget.currentUser);
    Map<String, dynamic> response =
        await f.getnotifications("arkadaslik", "istek", _page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _pageproccess = false;
      _firstFetchProcces = false;

      if (mounted) {
        setState(() {});
      }

      return;
    }
    if (_page == 1) {
      widgetNotifications.clear();
    }
    if (response["icerik"].length == 0) {
      _pageproccess = false;
      _firstFetchProcces = false;

      if (mounted) {
        setState(() {});
      }

      return;
    }

    bool noticiationbuttons = false;
    for (int i = 0; i < response["icerik"].length; i++) {
      noticiationbuttons = false;

      if (response["icerik"][i]["bildirimamac"].toString() == "arkadaslik") {
        if (response["icerik"][i]["bildirimkategori"].toString() == "istek") {
          noticiationbuttons = true;
        }
      } else if (response["icerik"][i]["bildirimamac"].toString() ==
          "gruplar") {
        if (response["icerik"][i]["bildirimkategori"].toString() == "davet") {
          noticiationbuttons = true;
        }
      }

      widgetNotifications.add(
        CustomMenusNotificationbars(
          currentUser: widget.currentUser,
          user: User(
            userID: response["icerik"][i]["bildirimgonderenID"],
            displayName: response["icerik"][i]["bildirimgonderenadsoyad"],
            avatar: Media(
              mediaID: response["icerik"][i]["bildirimgonderenID"],
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["bildirimgonderenavatar"],
                normalURL: response["icerik"][i]["bildirimgonderenavatar"],
                minURL: response["icerik"][i]["bildirimgonderenavatar"],
              ),
            ),
          ),
          category: response["icerik"][i]["bildirimamac"],
          categorydetail: response["icerik"][i]["bildirimkategori"],
          categorydetailID: response["icerik"][i]["bildirimkategoridetay"],
          date: response["icerik"][i]["bildirimzaman"],
          enableButtons: noticiationbuttons,
          text: response["icerik"][i]["bildirimicerik"],
        ),
      );

      setstatefunction();
    }

    _firstFetchProcces = false;
    _pageproccess = false;
    _page++;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: const Text("Arkadaşlık İstekleri"),
        backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async {
              _page = 1;
              await loadnoifications();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: _handleRefresh,
          ),
          widgetNotifications.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: !_firstFetchProcces && !_pageproccess
                        ? const Text("Arkadaşlık istek kutusu boş")
                        : const CupertinoActivityIndicator(),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: widgetNotifications.length,
                    (context, index) {
                      return Column(
                        children: [
                          widgetNotifications[index],
                          const SizedBox(height: 1)
                        ],
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
