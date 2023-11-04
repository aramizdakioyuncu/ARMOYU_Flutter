// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import '../Services/functions_service.dart';
import '../Widgets/notification-bars.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPage createState() => _NotificationPage();
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

  List<Widget> Widget_notifications = [];

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
        Widget_notifications.clear();
      }

      for (int i = 0; i < dynamicItemCount; i++) {
        Widget_notifications.add(
          CustomMenusNotificationbars().costom1(
              context,
              response["icerik"][i]["bildirimgonderenID"],
              response["icerik"][i]["bildirimgonderenadsoyad"],
              response["icerik"][i]["bildirimgonderenavatar"],
              response["icerik"][i]["bildirimicerik"],
              response["icerik"][i]["bildirimzaman"]),
        );
      }
    });
    postpageproccess = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          controller: _scrollController,
          children: [
            Center(
              child: Column(
                children: Widget_notifications,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
