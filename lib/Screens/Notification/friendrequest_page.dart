import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/notification_bars.dart';

class NotificationFriendRequestPage extends StatefulWidget {
  const NotificationFriendRequestPage({
    super.key,
  });

  @override
  State<NotificationFriendRequestPage> createState() => _NotificationPage();
}

bool postpageproccess = false;
int postpage = 1;
bool firstFetchProcces = true;
List<Widget> widgetNotifications = [];

final ScrollController _scrollController = ScrollController();

class _NotificationPage extends State<NotificationFriendRequestPage>
    with AutomaticKeepAliveClientMixin<NotificationFriendRequestPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    if (firstFetchProcces) {
      loadnoifications(postpage);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!postpageproccess) {
      await loadnoifications(postpage);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      postpage = 1;
      loadnoifications(postpage);
    });
  }

  Future<void> loadnoifications(int page) async {
    if (postpageproccess) {
      return;
    }
    postpageproccess = true;

    FunctionService f = FunctionService();
    Map<String, dynamic> response =
        await f.getnotifications("arkadaslik", "istek", page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      postpageproccess = false;
      firstFetchProcces = false;
      return;
    }

    if (page == 1) {
      widgetNotifications.clear();
    }
    if (response["icerik"].length == 0) {
      postpageproccess = false;
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
      if (mounted) {
        setState(() {
          widgetNotifications.add(
            CustomMenusNotificationbars(
              avatar: response["icerik"][i]["bildirimgonderenavatar"],
              userID: response["icerik"][i]["bildirimgonderenID"],
              category: response["icerik"][i]["bildirimamac"],
              categorydetail: response["icerik"][i]["bildirimkategori"],
              categorydetailID: response["icerik"][i]["bildirimkategoridetay"],
              date: response["icerik"][i]["bildirimzaman"],
              displayname: response["icerik"][i]["bildirimgonderenadsoyad"],
              enableButtons: noticiationbuttons,
              text: response["icerik"][i]["bildirimicerik"],
            ),
          );
        });
      }
    }
    postpageproccess = false;
    firstFetchProcces = false;

    postpage++;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arkadaşlık İstekleri"),
        backgroundColor: ARMOYU.appbarColor,
      ),
      backgroundColor: ARMOYU.bodyColor,
      body: widgetNotifications.isEmpty
          ? const Center(child: CupertinoActivityIndicator())
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widgetNotifications.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      widgetNotifications[index],
                      const SizedBox(height: 1)
                    ],
                  );
                },
              ),
            ),
    );
  }
}
