import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/notification_page/controllers/notification_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final ScrollController scrollController;

  const NotificationPage({
    super.key,
    required this.currentUserAccounts,
    required this.scrollController,
  });

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin<NotificationPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final NotificationPageController controller = Get.put(
      NotificationPageController(
        currentUserAccounts: widget.currentUserAccounts,
        scrollController: widget.scrollController,
      ),
      tag: widget.currentUserAccounts.user.userID.toString(),
    );

    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: Obx(
        () => controller.notificationlistwidget(),
      ),
    );
  }
}
