import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/notification_bars.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

bool postpageproccess = false;
int postpage = 1;
ScrollController _scrollController = ScrollController();

class _NotificationPage extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin<NotificationPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    loadnoifications(1);
    loadnoifications(2);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    postpage++;

    if (!postpageproccess && postpage != 2) {
      await loadnoifications(postpage);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      loadnoifications(1);
      loadnoifications(2);
    });
  }

  List<Widget> widgetNotifications = [];

  Future<void> loadnoifications(int page) async {
    if (postpageproccess && page != 2) {
      return;
    }

    postpageproccess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnotifications(page);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;
    setState(() {
      if (page == 1) {
        widgetNotifications.clear();
      }

      bool noticiationbuttons = false;
      for (int i = 0; i < dynamicItemCount; i++) {
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
      }
    });
    postpageproccess = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widgetNotifications.length,
          itemBuilder: (context, index) {
            return widgetNotifications[index];
          },
        ),
      ),
    );
  }
}
