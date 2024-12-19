import 'package:ARMOYU/app/modules/Events/_main/controllers/eventlist_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventlistPage extends StatelessWidget {
  const EventlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventlistController());
    return Scaffold(
      appBar: AppbarWidget.standart(title: DrawerKeys.drawerEvents.tr),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.geteventslist();
            },
          ),
          Obx(
            () => controller.eventsList.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: controller.eventsList[index].eventListWidget(
                            context,
                            currentUser: controller.currentUser.value!,
                          ),
                        );
                      },
                      childCount: controller.eventsList.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
