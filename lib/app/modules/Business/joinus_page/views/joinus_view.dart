import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Business/joinus_page/controllers/joinus_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinusView extends StatelessWidget {
  const JoinusView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JoinusController());
    return Scaffold(
      appBar: AppBar(
        title: CustomText.costum1(DrawerKeys.drawerJoinUs.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: [
              Container(color: ARMOYU.bodyColor, height: 1),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/armoyu512.png',
                  height: 150,
                  width: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText.costum1(
                  "* ${JoinUsKeys.phoneNumberRegistered.tr}\n"
                  "* ${JoinUsKeys.profilePhoto.tr}\n"
                  "* ${JoinUsKeys.noPenalty.tr}\n"
                  "* ${JoinUsKeys.noProvocation.tr}\n",
                  align: TextAlign.left,
                  color: Colors.red,
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButtons.costum2(
                    text: controller.category.value != null
                        ? '${controller.category.value}'
                        : JoinUsKeys.selectAnItem.tr,
                    onPressed: () {
                      WidgetUtility.cupertinoselector(
                        context: context,
                        title: JoinUsKeys.selectAnItem.tr,
                        // setstatefunction: controller.setstatefunction,
                        list: controller.departmentList.map((item) {
                          return item.map((key, value) {
                            return MapEntry(key, value["category"].toString());
                          });
                        }).toList(),
                        onChanged: (valueID, value) {
                          if (valueID == -1) {
                            return;
                          }
                          controller.category.value = value;

                          controller.filtereddepartmentdetailList.value =
                              controller.departmentdetailList.where((item) {
                            return item.values.first["category"] ==
                                controller.category;
                          }).toList();

                          controller.categorydetail.value =
                              JoinUsKeys.selectAPosition.tr;
                          controller.departmentabout.value = "";
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
                    text: controller.categorydetail.value != null
                        ? '${controller.categorydetail.value}'
                        : JoinUsKeys.selectAPosition.tr,
                    onPressed: () {
                      WidgetUtility.cupertinoselector(
                        context: context,
                        title: JoinUsKeys.selectAPosition.tr,
                        // setstatefunction: controller.setstatefunction,
                        list:
                            controller.filtereddepartmentdetailList.map((item) {
                          return item.map((key, value) {
                            return MapEntry(key, value["value"].toString());
                          });
                        }).toList(),
                        onChanged: (valueID, value) {
                          if (valueID == -1) {
                            return;
                          }
                          controller.categorydetail.value = value;
                          controller.positionID = controller
                              .filtereddepartmentdetailList[valueID]
                              .values
                              .first["ID"];
                          controller.departmentabout.value = controller
                              .filtereddepartmentdetailList[valueID]
                              .values
                              .first["about"]
                              .toString();
                        },
                      );
                    },
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText.costum1(
                    controller.departmentabout.value,
                    align: TextAlign.left,
                    color: Colors.amber,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfields.costum3(
                    title: JoinUsKeys.whyJoinTheTeam.tr,
                    minLines: 5,
                    maxLength: 200,
                    minLength: 20,
                    controller: controller.whyjointheteamController,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfields.costum3(
                    title: JoinUsKeys.whyChooseThisPermission.tr,
                    minLines: 3,
                    maxLength: 100,
                    minLength: 10,
                    controller: controller.whypositionController,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfields.costum3(
                    title: JoinUsKeys.howManyDaysPerWeek.tr,
                    minLines: 2,
                    maxLength: 50,
                    minLength: 5,
                    controller: controller.howmuchtimedoyouspareController,
                  ),
                ),
              ),
              Obx(
                () => CustomButtons.costum1(
                  text: CommonKeys.submit.tr,
                  onPressed: () async => await controller.requestjoinfunction(),
                  loadingStatus: controller.requestProccess,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
