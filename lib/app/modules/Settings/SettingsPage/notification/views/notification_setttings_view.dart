import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/notification/controllers/notification_settings_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsettingsView extends StatelessWidget {
  const NotificationsettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsettingsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SettingsKeys.notifications.tr,
        ),
        actions: [
          IconButton(
            onPressed: () async => controller.fetchNotificationdetail(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Obx(
              () => Column(
                children: [
                  ListTile(
                    title:
                        CustomText.costum1(NotificationsKeys.commentLikes.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.commentLikesExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiCommentLike == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiCommentLike!.value,
                                onChanged: (value) {
                                  controller.notifiCommentLike!.value =
                                      !controller.notifiCommentLike!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.postLikes.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.postLikesExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiPostLike == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiPostLike!.value,
                                onChanged: (value) {
                                  controller.notifiPostLike!.value =
                                      !controller.notifiPostLike!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.comment.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.commentExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiComments == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiComments!.value,
                                onChanged: (value) {
                                  controller.notifiComments!.value =
                                      !controller.notifiComments!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title:
                        CustomText.costum1(NotificationsKeys.commentReplies.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.commentRepliesExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiReplyComment == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiReplyComment!.value,
                                onChanged: (value) {
                                  controller.notifiReplyComment!.value =
                                      !controller.notifiReplyComment!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.event.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.eventExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiEvents == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiEvents!.value,
                                onChanged: (value) {
                                  controller.notifiEvents!.value =
                                      !controller.notifiEvents!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.birthdays.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.birthdaysExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiBirthdays == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiBirthdays!.value,
                                onChanged: (value) {
                                  controller.notifiBirthdays!.value =
                                      !controller.notifiBirthdays!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.messages.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.messagesExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiMessages == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiMessages!.value,
                                onChanged: (value) {
                                  controller.notifiMessages!.value =
                                      !controller.notifiMessages!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.calls.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.callsExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiCalling == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiCalling!.value,
                                onChanged: (value) {
                                  controller.notifiCalling!.value =
                                      !controller.notifiCalling!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(NotificationsKeys.mentions.tr),
                    subtitle: CustomText.costum1(
                      NotificationsKeys.mentionsExplain.tr,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.notifiMention == null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              )
                            : Switch(
                                value: controller.notifiMention!.value,
                                onChanged: (value) {
                                  controller.notifiMention!.value =
                                      !controller.notifiMention!.value;
                                },
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButtons.costum1(
                    text: "Güncelle",
                    onPressed: () async => controller.savenotifi(),
                    loadingStatus: controller.updatesettingProcess,
                    enabled: !controller.firstfetchnotifi.value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
