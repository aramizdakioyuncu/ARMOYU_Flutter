import 'dart:async';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/School/login_school_page/controllers/school_login_controller.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';

import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:get/get.dart';

class SchoolLoginPageView extends StatelessWidget {
  const SchoolLoginPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = Get.arguments;

    User user = arguments["currentUser"];
    final currentAccountController = Get.find<PagesController>(
      tag: user.userID.toString(),
    );
    final controller = Get.put(
      SchoolLoginController(
        currentUser: currentAccountController.currentUserAccount.user,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Okul Seçim"),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.handleRefresh(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Obx(
                  () => CachedNetworkImage(
                    imageUrl: controller.schoollogo.value,
                    height: 250,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
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
                            // setState(() {
                            controller.selectedcupertinolist.value =
                                selectedItem;

                            try {
                              controller.schoollogo.value = controller
                                  .cupertinolist[controller
                                      .selectedcupertinolist.value]["logo"]
                                  .toString();

                              Timer(const Duration(milliseconds: 700),
                                  () async {
                                if (controller.selectedcupertinolist
                                        .toString() !=
                                    selectedItem.toString()) {
                                  // isProcces = false;
                                  return;
                                }

                                controller.getschoolclass(
                                  controller.cupertinolist[controller
                                      .selectedcupertinolist.value]["ID"]!,
                                  controller.cupertinolist2,
                                );

                                // isProcces = false;
                              });
                            } catch (e) {
                              log(e.toString());
                            }
                            // });
                          },
                          children: List<Widget>.generate(
                              controller.cupertinolist.length, (int index) {
                            return Center(
                              child: Text(controller.cupertinolist[index]
                                      ["value"]
                                  .toString()),
                            );
                          }),
                        ),
                      );
                    },
                    child: Container(
                      width: ARMOYU.screenWidth - 10,
                      padding: const EdgeInsets.all(16.0),
                      color: ARMOYU.textbackColor,
                      child: Text(
                        controller.cupertinolist[
                                controller.selectedcupertinolist.value]["value"]
                            .toString(),
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      controller.showDialog(
                        CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: controller.kItemExtent.value,
                          scrollController: FixedExtentScrollController(
                            initialItem:
                                controller.selectedcupertinolist2.value,
                          ),
                          onSelectedItemChanged: (int selectedItem) async {
                            controller.selectedcupertinolist2.value =
                                selectedItem;
                          },
                          children: List<Widget>.generate(
                              controller.cupertinolist2.length, (int index) {
                            return Center(
                                child: Text(controller.cupertinolist2[index]
                                        ["value"]
                                    .toString()));
                          }),
                        ),
                      );
                    },
                    child: Container(
                      width: ARMOYU.screenWidth - 10,
                      padding: const EdgeInsets.all(16.0),
                      color: ARMOYU.textbackColor,
                      child: Text(
                        controller.cupertinolist2[controller
                                .selectedcupertinolist2.value]["value"]
                            .toString(),
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextfields.costum3(
                  title: "Parola",
                  controller: controller.schoolpassword,
                  isPassword: true,
                  preicon: const Icon(Icons.security),
                  type: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomButtons.costum1(
                  text: "Katıl",
                  onPressed: controller.loginschool,
                  loadingStatus: controller.schoolProcess,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
