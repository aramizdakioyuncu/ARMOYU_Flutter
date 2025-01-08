import 'package:armoyu_widgets/data/models/select.dart';
import 'package:ARMOYU/app/modules/Group/create_group_page/controllers/group_create_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/appbar_widget.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';

import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupCreateView extends StatelessWidget {
  const GroupCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupCreateController controller = Get.put(GroupCreateController());

    return Scaffold(
      appBar: AppbarWidget.standart(title: GroupKeys.createGroup.tr),
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
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButtons.costum2(
                      enabled: controller.groupcategoryList.value.list != null,
                      text: controller.groupcategory.value != null
                          ? '${controller.groupcategory.value}'
                          : JoinUsKeys.selectAnItem.tr,
                      onPressed: () {
                        WidgetUtility.cupertinoselector(
                          context: context,
                          title: JoinUsKeys.selectAnItem.tr,
                          selectionList: controller.groupcategoryList,
                          onChanged: (index, value) {
                            if (index == -1) {
                              return;
                            }
                            controller.groupcategory.value = value;
                            controller.groupcategorydetail.value =
                                JoinUsKeys.selectAnItem.tr;
                            controller.groupmaingamedetail.value = null;

                            controller.groupcategoryList.value.selectedIndex =
                                Rxn(index);

                            var categoryList =
                                controller.groupcategoryList.value;

                            categoryList.list![index].selectionList =
                                Selection(list: []).obs;

                            int index1 = controller.groupcategoryList.value
                                    .selectedIndex!.value! +
                                1;

                            controller.groupdetailfetch(
                                categoryList.list![index1].selectID.toString(),
                                categoryList.list![index].selectionList);
                          },
                        );
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButtons.costum2(
                      enabled:
                          controller.groupcategoryList.value.selectedIndex !=
                              null,
                      text: controller.groupcategorydetail.value != null
                          ? '${controller.groupcategorydetail.value}'
                          : JoinUsKeys.selectAnItem.tr,
                      onPressed: () {
                        int indexx1 = controller
                            .groupcategoryList.value.selectedIndex!.value!;

                        WidgetUtility.cupertinoselector(
                          context: context,
                          title: JoinUsKeys.selectAnItem.tr,
                          selectionList: controller.groupcategoryList.value
                              .list![indexx1].selectionList!,
                          onChanged: (index, value) async {
                            if (index == -1) {
                              return;
                            }
                            controller.groupcategorydetail.value = value;

                            controller
                                .groupcategoryList
                                .value
                                .list![indexx1]
                                .selectionList!
                                .value
                                .selectedIndex = Rxn(index + 1);

                            var categoryList = controller.groupcategoryList
                                .value.list![indexx1].selectionList!.value;

                            categoryList.list![index + 1].selectionList =
                                Selection(list: []).obs;

                            if (controller.groupcategoryList.value
                                    .list![indexx1 + 1].title
                                    .toString() ==
                                "Yazılım & Geliştirme") {
                              await controller.groupcreaterequest("Projeler",
                                  categoryList.list![index + 1].selectionList);
                            } else if (controller.groupcategoryList.value
                                    .list![indexx1 + 1].title
                                    .toString() ==
                                "E-Spor") {
                              await controller.groupcreaterequest("E-spor",
                                  categoryList.list![index + 1].selectionList);
                            } else {
                              await controller.groupcreaterequest(
                                  controller.groupcategoryList.value
                                      .list![indexx1 + 1].title,
                                  categoryList.list![index + 1].selectionList);
                            }

                            controller.groupmaingamedetail.value =
                                JoinUsKeys.selectAnItem.tr;
                          },
                        );
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButtons.costum2(
                      enabled: controller.groupmaingamedetail.value != null
                          ? true
                          : false,
                      text: controller.groupmaingamedetail.value != null
                          ? '${controller.groupmaingamedetail.value}'
                          : JoinUsKeys.selectAnItem.tr,
                      onPressed: () {
                        int indexx1 = controller
                            .groupcategoryList.value.selectedIndex!.value!;

                        int indexxx = controller
                            .groupcategoryList
                            .value
                            .list![indexx1]
                            .selectionList!
                            .value
                            .selectedIndex!
                            .value!;
                        WidgetUtility.cupertinoselector(
                          context: context,
                          title: JoinUsKeys.selectAnItem.tr,
                          selectionList: controller
                              .groupcategoryList
                              .value
                              .list![indexx1]
                              .selectionList!
                              .value
                              .list![indexxx]
                              .selectionList!,
                          onChanged: (index, value) {
                            if (index == -1) {
                              return;
                            }
                            controller.groupmaingamedetail.value = value;

                            // ignore: avoid_single_cascade_in_expression_statements
                            controller.groupcategoryList.value.list![indexx1]
                                .selectionList!.value.list![indexxx]
                              ..selectionList!.value.selectedIndex =
                                  Rxn(index + 1);
                          },
                        );
                      },
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
