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

bool _firstProccess = true;
bool _notificationProccess = false;
int _page = 1;

class _NotificationPage extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin<NotificationPage> {
  @override
  bool get wantKeepAlive => true;
  late final ScrollController _scrollController = widget.scrollController;
  @override
  void initState() {
    super.initState();

    loadnoifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!_notificationProccess) {
      await loadnoifications();
    }
  }

  Future<void> _handleRefresh() async {
    _page = 1;
    await loadnoifications();
  }

  List<Widget> widgetNotifications = [];

  Future<void> loadnoifications() async {
    if (_notificationProccess) {
      return;
    }
    _notificationProccess = true;
    if (mounted) {
      setState(() {});
    }
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnotifications("", "", _page);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _notificationProccess = false;
      _firstProccess = false;

      if (mounted) {
        setState(() {});
      }
      return;
    }

    if (_page == 1) {
      widgetNotifications.clear();
      if (mounted) {
        setState(() {});
      }
    }

    if (response["icerik"].length == 0) {
      _notificationProccess = false;
      _firstProccess = false;
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

    _notificationProccess = false;
    _firstProccess = false;
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
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              widgetNotifications.isEmpty
                  ? Container(
                      color: ARMOYU.backgroundcolor,
                      child: Stack(
                        children: [
                          Center(
                            child: !_firstProccess && !_notificationProccess
                                ? const Text("Bildirimler Boş")
                                : const CupertinoActivityIndicator(),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          leading: Icon(
                            Icons.person_add_rounded,
                            color: ARMOYU.color,
                          ),
                          tileColor: ARMOYU.appbarColor,
                          title: CustomText.costum1("Arkadaşlık İstekleri"),
                          subtitle: CustomText.costum1(
                              "Arkadaşlık isteklerini gözden geçir"),
                          trailing: Badge(
                            isLabelVisible:
                                ARMOYU.friendRequestCount == 0 ? false : true,
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
                                builder: (context) =>
                                    const NotificationFriendRequestPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
                          leading: Icon(Icons.groups_2, color: ARMOYU.color),
                          tileColor: ARMOYU.appbarColor,
                          title: CustomText.costum1("Grup İstekleri"),
                          subtitle: CustomText.costum1(
                              "Grup isteklerini gözden geçir"),
                          trailing: Badge(
                            isLabelVisible:
                                ARMOYU.groupInviteCount == 0 ? false : true,
                            label: Text(ARMOYU.groupInviteCount.toString()),
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
                                builder: (context) =>
                                    const NotificationGroupRequestPage(),
                              ),
                            );
                          },
                        ),
                        ...List.generate(
                          widgetNotifications.length,
                          (index) {
                            return Column(
                              children: [
                                widgetNotifications[index],
                                const SizedBox(height: 1)
                              ],
                            );
                          },
                        )
                        // ListView.builder(
                        //   physics: const AlwaysScrollableScrollPhysics(),
                        //   controller: _scrollController,
                        //   itemCount: widgetNotifications.length,
                        //   itemBuilder: (context, index) {
                        //     return Column(
                        //       children: [
                        //         widgetNotifications[index],
                        //         const SizedBox(height: 1)
                        //       ],
                        //     );
                        //   },
                        // ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
