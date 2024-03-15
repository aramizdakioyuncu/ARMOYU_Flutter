import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';

class SettingsNotificationPage extends StatefulWidget {
  const SettingsNotificationPage({super.key});

  @override
  State<SettingsNotificationPage> createState() => _SettingsNotificationPage();
}

class _SettingsNotificationPage extends State<SettingsNotificationPage> {
  bool notifiPostLike = true;
  bool notifiCommentLike = true;
  bool notifiLike = true;

  bool notifiComments = true;
  bool notifiReplyComment = true;

  bool notifiEvents = true;
  bool notifiBirthdays = true;
  bool notifiMessages = true;
  bool notifiCalling = true;
  bool notifiMention = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text('Bildirimler'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1("Yorum Beğenileri"),
                  subtitle: CustomText.costum1(
                      "Yorumlarınız beğenildiğinde bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiCommentLike,
                        onChanged: (value) {
                          setState(() {
                            notifiCommentLike = !notifiCommentLike;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Paylaşım Beğenileri"),
                  subtitle: CustomText.costum1(
                      "Paylaşımlarınız beğeni aldığında bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiPostLike,
                        onChanged: (value) {
                          setState(() {
                            notifiPostLike = !notifiPostLike;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Yorum"),
                  subtitle: CustomText.costum1(
                      "Paylaşımlarınız yorum aldığında bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiComments,
                        onChanged: (value) {
                          setState(() {
                            notifiComments = !notifiComments;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Yorum Yanıtları"),
                  subtitle: CustomText.costum1(
                      "Yorumunuza yanıt geldiğinde bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiReplyComment,
                        onChanged: (value) {
                          setState(() {
                            notifiReplyComment = !notifiReplyComment;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Etkinlik"),
                  subtitle: CustomText.costum1(
                      "Etkinlik ile ilgili tüm duyuruları bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiEvents,
                        onChanged: (value) {
                          setState(() {
                            notifiEvents = !notifiEvents;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Doğum Günleri"),
                  subtitle: CustomText.costum1(
                      "Arkadaşlarınızın doğum günlerini bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiBirthdays,
                        onChanged: (value) {
                          setState(() {
                            notifiBirthdays = !notifiBirthdays;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Mesajlar"),
                  subtitle:
                      CustomText.costum1("Yeni mesaj geldiğinde bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiMessages,
                        onChanged: (value) {
                          setState(() {
                            notifiMessages = !notifiMessages;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Aramalar"),
                  subtitle:
                      CustomText.costum1("Birisi sizi aradığında bildirir"),
                  tileColor: ARMOYU.bacgroundcolor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiCalling,
                        onChanged: (value) {
                          setState(() {
                            notifiCalling = !notifiCalling;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Bahsetmeler"),
                  subtitle:
                      CustomText.costum1("Etiketlendiğiniz her şeyi bildirir."),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: notifiMention,
                        onChanged: (value) {
                          setState(() {
                            notifiMention = !notifiMention;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
