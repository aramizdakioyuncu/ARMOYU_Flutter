import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/mainpage/Notification/_main/controllers/notification_page_controller.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:armoyu/app/widgets/bottomnavigationbar.dart';
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
            onRefresh: controller.notifications.refresh,
          ),
          SliverToBoxAdapter(
            child: controller.notificationsdetail,
          ),
          SliverToBoxAdapter(
            child: controller.notifications.widget.value!,
          ),
        ],
      ),
      bottomNavigationBar: BottomnavigationBar.custom1(),
    );
  }
}
