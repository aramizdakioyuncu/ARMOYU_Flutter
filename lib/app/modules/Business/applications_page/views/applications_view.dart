import 'package:armoyu/app/modules/Business/applications_page/controllers/applications_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:armoyu/app/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationsView extends StatelessWidget {
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplicationsController());
    return Scaffold(
      appBar: AppbarWidget.standart(
        title: DrawerKeys.drawerJoinUs.tr,
        actions: [
          IconButton(
            onPressed: () async =>
                await controller.fetchapplicationInfo(firstpage: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(
        () => controller.requestProccess.value ||
                controller.applicationList.isEmpty
            ? Center(
                child: !controller.requestProccess.value
                    ? CustomText.costum1(CommonKeys.empty.tr)
                    : const CupertinoActivityIndicator(),
              )
            : ListView.builder(
                itemCount: controller.applicationList.length,
                itemBuilder: (context, index) {
                  return controller.applicationList[index];
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => JoinUsBusinessView(
          //         currentUser: controller.currentUser.value!),
          //   ),
          // );

          Get.toNamed("/applications/create");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
