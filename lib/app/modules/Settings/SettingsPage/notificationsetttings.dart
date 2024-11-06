import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/API_Functions/notification.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SettingsNotificationPage extends StatefulWidget {
  final User currentUser;
  const SettingsNotificationPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<SettingsNotificationPage> createState() => _SettingsNotificationPage();
}

bool? _notifiPostLike;
bool? _notifiCommentLike;

bool? _notifiComments;
bool? _notifiReplyComment;

bool? _notifiEvents;
bool? _notifiBirthdays;
bool? _notifiMessages;
bool? _notifiCalling;
bool? _notifiMention;

var updatesettingProcess = false.obs;

bool _firstfetchnotifi = false;

List<String> settingsNotification = [];

class _SettingsNotificationPage extends State<SettingsNotificationPage> {
  @override
  void initState() {
    super.initState();
    if (_notifiCalling == null) {
      fetchNotificationdetail();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchNotificationdetail() async {
    if (_firstfetchnotifi) {
      return;
    }

    _firstfetchnotifi = true;
    setstatefunction();

    FunctionsNotification f =
        FunctionsNotification(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.listNotificationSettings();

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);

      _firstfetchnotifi = false;
      setstatefunction();
      return;
    }

    _notifiPostLike = response["icerik"]["paylasimbegeni"] == 1 ? true : false;
    _notifiCommentLike = response["icerik"]["yorumbegeni"] == 1 ? true : false;

    _notifiComments = response["icerik"]["paylasimyorum"] == 1 ? true : false;
    _notifiReplyComment = response["icerik"]["yorumyanit"] == 1 ? true : false;

    _notifiEvents = response["icerik"]["etkinlik"] == 1 ? true : false;
    _notifiBirthdays = response["icerik"]["dogumgunu"] == 1 ? true : false;
    _notifiMessages = response["icerik"]["mesajlar"] == 1 ? true : false;
    _notifiCalling = response["icerik"]["aramalar"] == 1 ? true : false;
    _notifiMention = response["icerik"]["bahsetmeler"] == 1 ? true : false;

    _firstfetchnotifi = false;
    setstatefunction();
  }

  Future<void> savenotifi() async {
    if (updatesettingProcess.value) {
      return;
    }
    updatesettingProcess.value = true;

    setstatefunction();

    settingsNotification = [];
    settingsNotification.add("paylasimbegeni= ${_notifiPostLike! ? 1 : 0}");
    settingsNotification.add("paylasimyorum=${_notifiComments! ? 1 : 0}");
    settingsNotification.add("yorumbegeni=${_notifiCommentLike! ? 1 : 0}");
    settingsNotification.add("dogumgunu=${_notifiBirthdays! ? 1 : 0}");
    settingsNotification.add("etkinlik=${_notifiEvents! ? 1 : 0}");
    settingsNotification.add("yorumyanit=${_notifiReplyComment! ? 1 : 0}");
    settingsNotification.add("mesajlar=${_notifiMessages! ? 1 : 0}");
    settingsNotification.add("aramalar=${_notifiCalling! ? 1 : 0}");
    settingsNotification.add("bahsetmeler=${_notifiMention! ? 1 : 0}");

    FunctionsNotification f =
        FunctionsNotification(currentUser: widget.currentUser);
    Map<String, dynamic> response =
        await f.updateNotificationSettings(settingsNotification);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);
      updatesettingProcess.value = false;
      setstatefunction();
      return;
    }
    ARMOYUWidget.toastNotification(response["aciklama"]);

    updatesettingProcess.value = false;
    if (mounted) {
      setstatefunction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SettingsKeys.notifications.tr,
        ),
        actions: [
          IconButton(
            onPressed: () async => fetchNotificationdetail(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1(NotificationsKeys.commentLikes.tr),
                  subtitle: CustomText.costum1(
                    NotificationsKeys.commentLikesExplain.tr,
                  ),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _notifiCommentLike == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiCommentLike!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiCommentLike = !_notifiCommentLike!;
                                });
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
                      _notifiPostLike == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiPostLike!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiPostLike = !_notifiPostLike!;
                                });
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
                      _notifiComments == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiComments!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiComments = !_notifiComments!;
                                });
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
                      _notifiReplyComment == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiReplyComment!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiReplyComment = !_notifiReplyComment!;
                                });
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
                      _notifiEvents == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiEvents!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiEvents = !_notifiEvents!;
                                });
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
                      _notifiBirthdays == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiBirthdays!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiBirthdays = !_notifiBirthdays!;
                                });
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
                      _notifiMessages == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiMessages!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiMessages = !_notifiMessages!;
                                });
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
                      _notifiCalling == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiCalling!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiCalling = !_notifiCalling!;
                                });
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
                      _notifiMention == null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Switch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            )
                          : Switch(
                              value: _notifiMention!,
                              onChanged: (value) {
                                setState(() {
                                  _notifiMention = !_notifiMention!;
                                });
                              },
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButtons.costum1(
                  text: "Güncelle",
                  onPressed: () async => savenotifi(),
                  loadingStatus: updatesettingProcess,
                  enabled: !_firstfetchnotifi,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
