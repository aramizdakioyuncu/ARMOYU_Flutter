import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Notification/friendrequest_page.dart';
import 'package:ARMOYU/Screens/Notification/grouprequest_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/notification_bars.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

bool postpageproccess = false;
int postpage = 1;

class _NotificationPage extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin<NotificationPage> {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController _scrollController = widget.scrollController;
  @override
  void initState() {
    super.initState();

    loadnoifications(postpage);

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
    await loadnoifications(postpage);

    setState(() {
      postpage = 1;
    });
  }

  List<Widget> widgetNotifications = [];

  Future<void> loadnoifications(int page) async {
    if (postpageproccess) {
      return;
    }
    postpageproccess = true;

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnotifications("", "", page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      postpageproccess = false;
      return;
    }

    if (page == 1) {
      widgetNotifications.clear();

      setState(() {
        widgetNotifications.add(ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          leading: Icon(
            Icons.person_add_rounded,
            color: ARMOYU.color,
          ),
          tileColor: ARMOYU.appbarColor,
          title: CustomText.costum1("Arkadaşlık İstekleri"),
          subtitle: CustomText.costum1("Arkadaşlık isteklerini gözden geçir"),
          trailing: Badge(
            isLabelVisible: ARMOYU.friendRequestCount == 0 ? false : true,
            label: Text(ARMOYU.friendRequestCount.toString()),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationFriendRequestPage(),
              ),
            );
          },
        ));
      });
      setState(() {
        widgetNotifications.add(ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          leading: Icon(Icons.groups_2, color: ARMOYU.color),
          tileColor: ARMOYU.appbarColor,
          title: CustomText.costum1("Grup İstekleri"),
          subtitle: CustomText.costum1("Grup isteklerini gözden geçir"),
          trailing: Badge(
            isLabelVisible: ARMOYU.GroupInviteCount == 0 ? false : true,
            label: Text(ARMOYU.GroupInviteCount.toString()),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationGroupRequestPage(),
              ),
            );
          },
        ));
      });
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
    postpageproccess = false;
    postpage++;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
