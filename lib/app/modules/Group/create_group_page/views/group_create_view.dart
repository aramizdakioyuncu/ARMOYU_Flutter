import 'dart:async';

import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/modules/Group/create_group_page/controllers/group_create_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';

import 'package:ARMOYU/app/widgets/textfields.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GroupCreateView extends StatelessWidget {
  const GroupCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupCreateController controller = Get.put(GroupCreateController());

    return Scaffold(
      appBar: AppBar(
        title: Text(GroupKeys.createGroup.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: 16),
                CustomTextfields.costum3(
                  title: GroupKeys.groupName.tr,
                  controller: controller.groupname,
                  isPassword: false,
                  preicon: const Icon(Icons.business),
                ),
                const SizedBox(height: 16),
                CustomTextfields.costum3(
                  title: GroupKeys.groupShortname.tr,
                  controller: controller.groupshortname,
                  isPassword: false,
                  preicon: const Icon(Icons.label),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (controller.isProcces.value) {
                      return;
                    }

                    controller.isProcces.value = true;
                    controller.showDialog(
                      CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: controller.kItemExtent.value,
                        scrollController: FixedExtentScrollController(
                          initialItem: controller.selectedcupertinolist.value,
                        ),
                        onSelectedItemChanged: (int selectedItem) async {
                          controller.selectedcupertinolist.value = selectedItem;

                          Timer(const Duration(milliseconds: 700), () async {
                            if (controller.selectedcupertinolist.value
                                    .toString() !=
                                selectedItem.toString()) {
                              controller.isProcces.value = false;
                              return;
                            }

                            controller.groupdetailfetch(
                              controller.cupertinolist[selectedItem]["ID"]
                                  .toString(),
                              controller.cupertinolist2,
                            );

                            if (controller.cupertinolist[selectedItem]["value"]
                                    .toString() ==
                                "E-spor") {
                              controller.groupcreaterequest(
                                "E-spor",
                                controller.cupertinolist3,
                              );
                              controller.isProcces.value = false;

                              return;
                            }
                            if (controller.cupertinolist[selectedItem]["value"]
                                    .toString() ==
                                "Spor") {
                              controller.groupcreaterequest(
                                "Spor",
                                controller.cupertinolist3,
                              );
                              controller.isProcces.value = false;

                              return;
                            }
                            if (controller.cupertinolist[selectedItem]["value"]
                                    .toString() ==
                                "Yazılım & Geliştirme") {
                              controller.groupcreaterequest(
                                "projeler",
                                controller.cupertinolist3,
                              );
                              controller.isProcces.value = false;

                              return;
                            }
                            controller.isProcces.value = false;
                          });
                        },
                        children: List<Widget>.generate(
                            controller.cupertinolist.length, (int index) {
                          return Center(
                            child: Text(
                              controller.cupertinolist[index]["value"]
                                  .toString(),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                  child: Container(
                    width: ARMOYU.screenWidth - 10,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.shade900,
                    child: Text(
                      controller
                          .cupertinolist[controller.selectedcupertinolist.value]
                              ["value"]
                          .toString(),
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => controller.showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: controller.kItemExtent.value,
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedcupertinolist2.value,
                      ),
                      onSelectedItemChanged: (int selectedItem) async {
                        // setState(() {
                        controller.selectedcupertinolist2.value = selectedItem;
                        // });
                      },
                      children: List<Widget>.generate(
                          controller.cupertinolist2.length, (int index) {
                        return Center(
                          child: Text(
                            controller.cupertinolist2[index]["value"]
                                .toString(),
                          ),
                        );
                      }),
                    ),
                  ),
                  child: Container(
                    width: ARMOYU.screenWidth - 10,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.shade900,
                    child: Text(
                      controller.cupertinolist2[
                              controller.selectedcupertinolist2.value]["value"]
                          .toString(),
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => controller.showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: controller.kItemExtent.value,
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedcupertinolist3.value,
                      ),
                      onSelectedItemChanged: (int selectedItem) {
                        // setState(() {
                        controller.selectedcupertinolist3.value = selectedItem;
                        // });
                      },
                      children: List<Widget>.generate(
                          controller.cupertinolist3.length, (int index) {
                        return Center(
                            child: Text(controller.cupertinolist3[index]
                                    ["value"]
                                .toString()));
                      }),
                    ),
                  ),
                  child: Container(
                    width: ARMOYU.screenWidth - 10,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.shade900,
                    child: Text(
                      controller.cupertinolist3[
                              controller.selectedcupertinolist3.value]["value"]
                          .toString(),
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButtons.costum1(
                  text: GroupKeys.createGroup.tr,
                  onPressed: controller.creategroupfunction,
                  loadingStatus: controller.groupcreateProcess,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
