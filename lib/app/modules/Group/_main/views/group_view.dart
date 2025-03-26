import 'dart:developer';

import 'package:armoyu/app/core/widgets.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu/app/modules/Group/_main/controllers/group_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/buttons.dart';
import 'package:armoyu/app/widgets/shimmer/placeholder.dart';
import 'package:armoyu/app/widgets/text.dart';
import 'package:armoyu/app/widgets/textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class GroupView extends StatelessWidget {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupController());
    return Scaffold(
      body: Obx(
        () => NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CupertinoSliverRefreshControl(
                onRefresh: () async => await controller.fetchusersfunction(),
              ),
              SliverAppBar(
                pinned: true,
                floating: false,
                leading: BackButton(
                  onPressed: () {
                    Get.back();
                  },
                ),
                backgroundColor: Colors.black,
                expandedHeight: ARMOYU.screenHeight * 0.25,
                actions: const <Widget>[],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 30.0),
                  centerTitle: false,
                  title: Stack(
                    children: [
                      Wrap(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              children: [
                                controller.group.value!.groupLogo == null
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: const CircleAvatar(
                                          radius:
                                              30.0, // Adjust the radius as needed
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                          controller.group.value!.groupLogo!
                                              .mediaURL.minURL.value,
                                        ),
                                        radius: 24,
                                      ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: controller.group.value!.groupName ==
                                            null
                                        ? Shimmer.fromColors(
                                            baseColor: Get.theme.disabledColor,
                                            highlightColor:
                                                Get.theme.highlightColor,
                                            child: Container(width: 100),
                                          )
                                        : Text(
                                            controller.group.value!.groupName
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  background: controller.group.value!.groupBanner == null
                      ? null
                      : CachedNetworkImage(
                          imageUrl: controller
                              .group.value!.groupBanner!.mediaURL.minURL.value,
                          progressIndicatorBuilder: (context, url, progress) =>
                              const CupertinoActivityIndicator(),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: controller.ismyGroup.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectmenuItem(0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.house,
                                  color: controller.selectedmenuItem.value == 0
                                      ? controller.selectedColor.value
                                      : controller.nonselectedColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.user.value!.myGroups == null
                            ? false
                            : controller.user.value!.myGroups!.any((mygroup) =>
                                    mygroup.groupID ==
                                    controller.group.value!.groupID)
                                ? controller.user.value!.myGroups!
                                    .firstWhere((mygroup) =>
                                        mygroup.groupID ==
                                        controller.group.value!.groupID)
                                    .myRole!
                                    .userInvite
                                : false,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectmenuItem(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.userPlus,
                                  color: controller.selectedmenuItem.value == 1
                                      ? controller.selectedColor.value
                                      : controller.nonselectedColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.user.value!.myGroups == null
                            ? false
                            : controller.user.value!.myGroups!.any((mygroup) =>
                                    mygroup.groupID ==
                                    controller.group.value!.groupID)
                                ? controller.user.value!.myGroups!
                                    .firstWhere((mygroup) =>
                                        mygroup.groupID ==
                                        controller.group.value!.groupID)
                                    .myRole!
                                    .groupSettings
                                : false,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectmenuItem(2);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.gear,
                                  color: controller.selectedmenuItem.value == 2
                                      ? controller.selectedColor.value
                                      : controller.nonselectedColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.user.value!.myGroups == null
                            ? false
                            : controller.user.value!.myGroups!.any((mygroup) =>
                                    mygroup.groupID ==
                                    controller.group.value!.groupID)
                                ? controller.user.value!.myGroups!
                                    .firstWhere((mygroup) =>
                                        mygroup.groupID ==
                                        controller.group.value!.groupID)
                                    .myRole!
                                    .groupSurvey
                                : false,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectmenuItem(2);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.chartBar,
                                  color: controller.selectedmenuItem.value == 3
                                      ? controller.selectedColor.value
                                      : controller.nonselectedColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.user.value!.myGroups == null
                            ? false
                            : controller.user.value!.myGroups!.any((mygroup) =>
                                    mygroup.groupID ==
                                    controller.group.value!.groupID)
                                ? controller.user.value!.myGroups!
                                    .firstWhere((mygroup) =>
                                        mygroup.groupID ==
                                        controller.group.value!.groupID)
                                    .myRole!
                                    .groupFiles
                                : false,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectmenuItem(2);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.upload,
                                  color: controller.selectedmenuItem.value == 4
                                      ? controller.selectedColor.value
                                      : controller.nonselectedColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectmenuItem(2);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.plug,
                                  color: controller.selectedmenuItem.value == 5
                                      ? controller.selectedColor.value
                                      : controller.nonselectedColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () async {
                            ARMOYUWidget.showConfirmationDialog(
                              context,
                              accept: controller.leavegroup,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.arrowRightFromBracket,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              )
            ];
          },
          body: PageView(
            scrollDirection: Axis.horizontal,
            controller: controller.pageviewController.value,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //Üye Listesi
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async =>
                        await controller.fetchusersfunction(),
                  ),
                  Obx(
                    () => controller.group.value!.groupUsers == null
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: [
                                ShimmerPlaceholder.listTilePlaceholder(),
                                ShimmerPlaceholder.listTilePlaceholder(),
                                ShimmerPlaceholder.listTilePlaceholder(),
                                ShimmerPlaceholder.listTilePlaceholder(),
                                ShimmerPlaceholder.listTilePlaceholder(),
                              ],
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                            childCount:
                                controller.group.value!.groupUsers!.length,
                            (context, index) {
                              return ListTile(
                                onTap: () {
                                  PageFunctions functions = PageFunctions();

                                  functions.pushProfilePage(
                                    context,
                                    User(
                                      userID: controller.group.value!
                                          .groupUsers![index].userID,
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  if (controller.user.value!.myGroups == null) {
                                    return;
                                  }

                                  if (!controller.user.value!.myGroups!.any(
                                      (mygroup) =>
                                          mygroup.groupID ==
                                          controller.group.value!.groupID)) {
                                    return;
                                  }

                                  if ((controller.user.value!.myGroups == null
                                              ? false
                                              : controller.user.value!.myGroups!
                                                      .any(
                                                  (mygroup) =>
                                                      mygroup.groupID ==
                                                      controller
                                                          .group.value!.groupID,
                                                )
                                                  ? controller
                                                      .user.value!.myGroups!
                                                      .firstWhere(
                                                        (mygroup) =>
                                                            mygroup.groupID ==
                                                            controller.group
                                                                .value!.groupID,
                                                      )
                                                      .myRole!
                                                      .userKick
                                                  : false)
                                          .toString() ==
                                      "false") {
                                    return;
                                  }
                                  //
                                  showModalBottomSheet<void>(
                                    backgroundColor:
                                        Get.theme.scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SafeArea(
                                        child: Wrap(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[900],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(30),
                                                      ),
                                                    ),
                                                    width:
                                                        ARMOYU.screenWidth / 4,
                                                    height: 5,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async =>
                                                      await controller
                                                          .removeuserfromgroup(
                                                              index),
                                                  child: const ListTile(
                                                    textColor: Colors.red,
                                                    leading: Icon(
                                                      Icons.person_off_outlined,
                                                      color: Colors.red,
                                                    ),
                                                    title: Text(
                                                      "Kullanıcıyı At.",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    controller.group.value!.groupUsers![index]
                                        .avatar!.mediaURL.normalURL.value,
                                  ),
                                ),
                                title: CustomText.costum1(
                                  controller.group.value!.groupUsers![index]
                                      .displayName
                                      .toString(),
                                ),
                                subtitle: CustomText.costum1(
                                  controller.group.value!.groupUsers![index]
                                      .role!.name
                                      .toString(),
                                ),
                              );
                            },
                          )),
                  )
                ],
              ),

              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: CustomTextfields.costum3(
                              controller: controller.searchuser,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButtons.costum1(
                              text: CommonKeys.invite.tr,
                              onPressed: controller.inviteuserfunction,
                              enabled: controller.selectedUsers.isNotEmpty
                                  ? true
                                  : false,
                              loadingStatus: controller.inviteuserStatus,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomText.costum1(
                          "(${controller.selectedUsers.length} ${GroupKeys.groupInviteNumberuserSelected.tr})",
                        ),
                      ),
                      ...List.generate(controller.searchUserList.length,
                          (index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundImage: CachedNetworkImageProvider(
                              controller.searchUserList[index].avatar!.mediaURL
                                  .minURL.value,
                            ),
                          ),
                          title: CustomText.costum1(
                            controller.searchUserList[index].displayName!.value,
                          ),
                          trailing: controller.group.value!.groupUsers!.any(
                                  (element) =>
                                      element.userID ==
                                      controller.searchUserList[index].userID)
                              ? CustomText.costum1(GroupKeys.groupMember.tr)
                              : Checkbox(
                                  value: controller.selectedUsers.any(
                                      (element) =>
                                          element.userID ==
                                          controller
                                              .searchUserList[index].userID),
                                  onChanged: (value) {
                                    if (value == true) {
                                      controller.selectedUsers.add(
                                          controller.searchUserList[index]);
                                    } else {
                                      controller.selectedUsers.removeWhere(
                                          (element) =>
                                              element.userID ==
                                              controller.searchUserList[index]
                                                  .userID);
                                    }
                                    log(controller.selectedUsers.length
                                        .toString());

                                    () {}();
                                  },
                                ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText.costum1(
                          GroupKeys.groupLogo.tr,
                        )
                      ],
                    ),
                    controller.group.value!.groupLogo == null
                        ? Shimmer.fromColors(
                            baseColor: Get.theme.disabledColor,
                            highlightColor: Get.theme.highlightColor,
                            child: const SizedBox(
                              height: 100,
                            ),
                          )
                        : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  controller.group.value!.groupLogo!.mediaURL
                                      .minURL.value,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    CustomButtons.costum1(
                      text: CommonKeys.change.tr,
                      onPressed: controller.changegrouplogo,
                      loadingStatus: controller.changegrouplogoStatus,
                    ),
                    Row(
                      children: [
                        CustomText.costum1(
                          GroupKeys.groupbanner.tr,
                        ),
                      ],
                    ),
                    controller.group.value!.groupBanner == null
                        ? Shimmer.fromColors(
                            baseColor: Get.theme.disabledColor,
                            highlightColor: Get.theme.highlightColor,
                            child: const SizedBox(
                              height: 100,
                            ),
                          )
                        : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                controller.group.value!.groupBanner!.mediaURL
                                    .minURL.value,
                              )),
                            ),
                          ),
                    const SizedBox(height: 10),
                    CustomButtons.costum1(
                      text: CommonKeys.change.tr,
                      onPressed: controller.changegroupbanner,
                      loadingStatus: controller.changegroupbannerStatus,
                    ),
                    CustomTextfields.costum3(
                      controller: controller.groupname,
                      title: GroupKeys.groupName.tr,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfields.costum3(
                      controller: controller.groupshortname,
                      title: GroupKeys.groupShortname.tr,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfields.costum3(
                      controller: controller.groupdescription,
                      title: GroupKeys.groupdescription.tr,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CustomText.costum1(GroupKeys.groupisJoinable.tr),
                        const Spacer(),
                        controller.group.value!.joinStatus == null
                            ? Container()
                            : Switch(
                                value:
                                    controller.group.value!.joinStatus!.value,
                                onChanged: (value) {
                                  controller.group.value!.joinStatus!.value =
                                      value;
                                },
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextfields.costum3(
                      controller: controller.socialdiscord,
                      title: "Discord",
                    ),
                    const SizedBox(height: 20),
                    CustomTextfields.costum3(
                      controller: controller.socialweb,
                      title: GroupKeys.groupwebsite.tr,
                    ),
                    const SizedBox(height: 20),
                    CustomButtons.costum1(
                      text: CommonKeys.save.tr,
                      onPressed: controller.groupdetailSave,
                      loadingStatus: controller.groupdetailSaveproccess,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
