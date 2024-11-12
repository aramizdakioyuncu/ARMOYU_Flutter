import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/_main/controllers/notification_page_controller.dart';
import 'package:ARMOYU/app/widgets/appbar_widget.dart';
import 'package:ARMOYU/app/widgets/bottomnavigationbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;

  const NotificationPage({
    super.key,
    required this.currentUserAccounts,
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
    final controller = Get.put(
      NotificationPageController(
        currentUserAccounts: widget.currentUserAccounts,
      ),
      tag: widget.currentUserAccounts.user.value.userID.toString(),
    );
//
    return Scaffold(
      appBar: AppbarWidget.custom(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.scrollController.value,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: controller.handleRefresh,
          ),
          Obx(
            () => controller.notificationlistwidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomnavigationBar.custom1(),
    );
  }
}
