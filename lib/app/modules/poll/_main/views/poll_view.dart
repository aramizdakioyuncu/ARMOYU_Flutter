import 'package:armoyu/app/modules/poll/_main/controllers/poll_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollView extends StatelessWidget {
  const PollView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PollController());
    return Scaffold(
      appBar: AppbarWidget.standart(
        title: DrawerKeys.drawerPolls.tr,
      ),
      body: CustomScrollView(
        controller: controller.controller.value,
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.fetchsurveys(
                restartfetch: true,
              );
            },
          ),
          Obx(
            () => controller.firstfetching.value
                ? const SliverFillRemaining(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                : SliverList.builder(
                    itemCount: controller.surveyList.length,
                    itemBuilder: (context, index) {
                      return controller.surveyList[index].surveyList(context);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "NewChatButton",
        onPressed: () {
          Get.toNamed("/poll/create");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
