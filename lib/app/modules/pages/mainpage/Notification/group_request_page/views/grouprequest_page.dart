import 'dart:developer';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/widgets/notification_bars.dart';

class NotificationGroupRequestPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  const NotificationGroupRequestPage({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  State<NotificationGroupRequestPage> createState() => _NotificationPage();
}

bool postpageproccess = false;
int postpage = 1;
bool firstFetchProcces = true;
List<CustomMenusNotificationbars> widgetNotifications = [];

final ScrollController _scrollController = ScrollController();

class _NotificationPage extends State<NotificationGroupRequestPage>
    with AutomaticKeepAliveClientMixin<NotificationGroupRequestPage> {
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

    setState(() {
      postpageproccess = true;
    });
    if (page == 1) {
      widgetNotifications.clear();
    }
    FunctionService f =
        FunctionService(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response =
        await f.getnotifications("gruplar", "davet", page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      setState(() {
        firstFetchProcces = false;
        postpageproccess = false;
      });
      return;
    }

    if (response["icerik"].length == 0) {
      setState(() {
        firstFetchProcces = false;
        postpageproccess = false;
      });
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
              currentUserAccounts: widget.currentUserAccounts,
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
        });
      }
    }

    firstFetchProcces = false;
    postpageproccess = false;
    if (mounted) {
      setState(() {});
    }

    postpage++;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grup İstekleri"),
        // backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async {
              postpage = 1;
              await loadnoifications(postpage);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: widgetNotifications.isEmpty
            ? Center(
                child: !firstFetchProcces && !postpageproccess
                    ? const Text("Grup istek kutusu boş")
                    : const CupertinoActivityIndicator(),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
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
