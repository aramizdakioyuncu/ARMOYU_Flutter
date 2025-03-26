import 'package:armoyu/app/core/widgets.dart';
import 'package:armoyu/app/modules/Invite/invite_page/controllers/invite_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InviteView extends StatelessWidget {
  const InviteView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InviteController());

    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController.value,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            leading: const BackButton(
              color: Colors.white,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () async {
                  controller.invitePage.value = 1;
                  await controller.invitepeoplelist();
                },
              )
            ],
            pinned: true,
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            expandedHeight: ARMOYU.screenHeight * 0.25,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl:
                    "https://img.freepik.com/premium-photo/abstract-background-modern-office-building-exterior-new-business-district_31965-133971.jpg",
                fit: BoxFit.cover,
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 00.0),
              title: Stack(
                children: [
                  Obx(
                    () => Wrap(
                      children: [
                        Column(
                          children: [
                            Visibility(
                              visible: controller.shouldShowTitle.value,
                              child: Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    controller.currentUserAccounts.value!.user
                                        .value.avatar!.mediaURL.normalURL.value,
                                  ),
                                  radius: 25,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: controller.shouldShowTitle.value,
                              child: const SizedBox(height: 10),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async =>
                                          await controller.refreshInviteCode(),
                                      child: const Icon(
                                        color: Colors.white,
                                        Icons.refresh,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    InkWell(
                                      onTap: () {
                                        controller
                                                    .currentUserAccounts
                                                    .value!
                                                    .user
                                                    .value
                                                    .detailInfo!
                                                    .value!
                                                    .inviteCode
                                                    .value ==
                                                null
                                            ? null
                                            : Clipboard.setData(
                                                ClipboardData(
                                                  text: controller
                                                      .currentUserAccounts
                                                      .value!
                                                      .user
                                                      .value
                                                      .detailInfo!
                                                      .value!
                                                      .inviteCode
                                                      .value
                                                      .toString(),
                                                ),
                                              );
                                        ARMOYUWidget.toastNotification(
                                          "Kod koyalandı",
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => controller
                                                        .currentUserAccounts
                                                        .value!
                                                        .user
                                                        .value
                                                        .detailInfo!
                                                        .value!
                                                        .inviteCode
                                                        .value ==
                                                    null
                                                ? Container()
                                                : Text(
                                                    controller
                                                        .currentUserAccounts
                                                        .value!
                                                        .user
                                                        .value
                                                        .detailInfo!
                                                        .value!
                                                        .inviteCode
                                                        .value!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(width: 2),
                                          const Icon(
                                            Icons.copy,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !controller.shouldShowTitle.value,
                              child: const SizedBox(height: 20),
                            ),
                            Visibility(
                              visible: controller.shouldShowTitle.value,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.amber,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${InviteKeys.normalAccount.tr} : ",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          controller.unauthroizedUserCount
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${InviteKeys.verifiedAccount.tr} : ",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          controller.authroizedUserCount
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              controller.invitePage.value = 1;
              await controller.invitepeoplelist();
            },
          ),
          Obx(
            () => controller.invitelist.isEmpty
                ? SliverFillRemaining(
                    child: !controller.isfirstfetch.value &&
                            !controller.inviteListProcces.value
                        ? Center(
                            child: Text(CommonKeys.empty.tr),
                          )
                        : const CupertinoActivityIndicator(),
                  )
                : SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(
                        controller.invitelist.length,
                        (index) => controller.invitelist[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
