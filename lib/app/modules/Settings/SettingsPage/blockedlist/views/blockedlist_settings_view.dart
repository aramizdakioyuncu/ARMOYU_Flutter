import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/blockedlist/controllers/blockedlist_settings_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedlistSettingsView extends StatelessWidget {
  const BlockedlistSettingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlockedlistSettingsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SettingsKeys.blockedList.tr,
        ),
        actions: [
          IconButton(
              onPressed: () async => await controller.getblockedlist(),
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Container(color: ARMOYU.bodyColor, height: 1),
          Expanded(
            child: Obx(
              () => controller.blockedList.isEmpty
                  ? Center(
                      child: !controller.blockedProcces.value &&
                              !controller.isFirstProcces.value
                          ? Text(BlockedListKeys.noBlockedAccounts.tr)
                          : const CupertinoActivityIndicator(),
                    )
                  : ListView.builder(
                      itemCount: controller.blockedList.length,
                      itemBuilder: (context, index) {
                        final Map<int, Widget> blockedUserMap =
                            controller.blockedList[index];
                        final Widget userWidget = blockedUserMap.values.first;

                        return userWidget;
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
