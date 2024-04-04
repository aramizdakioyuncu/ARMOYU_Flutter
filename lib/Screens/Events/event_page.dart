import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/event.dart';
import 'package:ARMOYU/Models/event.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Group/group_page.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({
    super.key,
    required this.event,
  });
  final Event event;
  @override
  State<EventPage> createState() => _EventStatePage();
}

class _EventStatePage extends State<EventPage> {
  bool didijoin = false;

  bool rulesacception = false;

  List<User> userParticipant = [];
  List<Group> groupParticipant = [];
  bool fetchParticipantProccess = false;

  bool joineventProccess = false;
  @override
  void initState() {
    super.initState();
    fetchparticipantList(widget.event.eventID);
  }

  Future<void> fetchparticipantList(eventID) async {
    if (fetchParticipantProccess) {
      return;
    }
    setState(() {
      fetchParticipantProccess = true;
    });
    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response = await f.participantList(eventID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      setState(() {
        fetchParticipantProccess = false;
      });
      return;
    }
    if (mounted) {
      setState(() {
        userParticipant.clear();
        groupParticipant.clear();
      });
    }

    //Gruplu Katılımcılar
    int sayac = -1;
    for (var element in response["icerik"]["participant_groups"]) {
      sayac++;

      List<User> groupUsers = [];
      for (var element2 in response["icerik"]["participant_groups"][sayac]
          ["group_players"]) {
        groupUsers.add(
          User(
            userID: element2["player_ID"],
            displayName: element2["player_name"],
            userName: element2["player_username"],
            avatar: Media(
              mediaID: element2["player_ID"],
              mediaURL: MediaURL(
                bigURL: element2["player_avatar"],
                normalURL: element2["player_avatar"],
                minURL: element2["player_avatar"],
              ),
            ),
            role: element2["player_role"],
          ),
        );
      }

      Group g = Group(
        groupID: element["group_ID"],
        groupLogo: Media(
          mediaID: element["group_ID"],
          mediaURL: MediaURL(
            bigURL: element["group_logo"],
            normalURL: element["group_logo"],
            minURL: element["group_logo"],
          ),
        ),
        groupBanner: Media(
          mediaID: element["group_ID"],
          mediaURL: MediaURL(
            bigURL: element["group_banner"],
            normalURL: element["group_banner"],
            minURL: element["group_banner"],
          ),
        ),
        groupName: element["group_name"],
        groupshortName: element["group_shortname"],
        groupUsers: groupUsers,
      );
      groupParticipant.add(g);
    }

    //Bireysel Katılımcılar
    for (var element in response["icerik"]["participant_players"]) {
      // log("Oyuncu: -> " + element["player_name"]);

      if (element["player_ID"] == ARMOYU.Appuser.userID) {
        setState(() {
          didijoin = true;
        });
      }

      userParticipant.add(
        User(
          userID: element["player_ID"],
          displayName: element["player_name"],
          userName: element["player_username"],
          avatar: Media(
            mediaID: element["player_ID"],
            mediaURL: MediaURL(
              bigURL: element["player_avatar"],
              normalURL: element["player_avatar"],
              minURL: element["player_avatar"],
            ),
          ),
        ),
      );
    }
    if (mounted) {
      setState(() {
        fetchParticipantProccess = false;
      });
    }
  }

  Future<void> joinevent() async {
    if (!rulesacception) {
      String gelenyanit = "Kuralları kabul etmediniz!";
      ARMOYUWidget.stackbarNotification(context, gelenyanit);
      return;
    }

    joineventProccess = true;
    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response =
        await f.joinOrleave(widget.event.eventID, true);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    await fetchparticipantList(widget.event.eventID);
    joineventProccess = false;
  }

  Future<void> leaveevent() async {
    joineventProccess = true;
    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response =
        await f.joinOrleave(widget.event.eventID, false);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    setState(() {
      didijoin = false;
    });

    await fetchparticipantList(widget.event.eventID);

    joineventProccess = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        appBar: AppBar(
          title: const Text('Etkinlikler'),
          backgroundColor: ARMOYU.appbarColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.event.image,
                placeholder: (context, url) => const SizedBox(
                  height: 40,
                  width: 40,
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: (context, url, error) => ErrorWidget("exception"),
                fit: BoxFit.cover,
                width: ARMOYU.screenWidth,
              ),
              const SizedBox(height: 50),
              const Text("Son Katılım Tarihi"),
              Text(
                widget.event.eventDate,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemCount: widget.event.eventorganizer.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0),
                        child: Column(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: widget.event.eventorganizer[index]
                                    .avatar!.mediaURL.minURL,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(widget
                                .event.eventorganizer[index].displayName!),
                            const Text(
                                "Yetkili"), // Yetkili bilgisini isteğinize göre güncelleyebilirsiniz
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Kurallar",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.event.rules),
                    const SizedBox(height: 10),
                    const Text(
                      "Açıklama",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.event.description),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              groupParticipant.isNotEmpty
                  ? SizedBox(
                      height: 600,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                        scrollDirection: Axis.horizontal,
                        itemCount: groupParticipant.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            width: ARMOYU.screenWidth - 30,
                            color: ARMOYU.appbarColor,
                            child: Column(
                              children: [
                                Container(
                                  height: 190,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        groupParticipant[index]
                                            .groupBanner!
                                            .mediaURL
                                            .minURL,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (content) =>
                                                  const GroupPage(),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                            groupParticipant[index]
                                                .groupLogo!
                                                .mediaURL
                                                .minURL,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          groupParticipant[index]
                                              .groupName
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                            ),
                                            child: Text(
                                              groupParticipant[index]
                                                  .groupshortName
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                            ),
                                            child: Text(
                                              "${groupParticipant[index].groupUsers!.length}/${widget.event.participantsgroupplayerlimit}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: List.generate(
                                        groupParticipant[index]
                                            .groupUsers!
                                            .length,
                                        (index2) => Container(
                                          width: ARMOYU.screenWidth - 50,
                                          alignment: Alignment.bottomLeft,
                                          decoration: index2 == 0
                                              ? const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.yellow,
                                                    ],
                                                  ),
                                                )
                                              : const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  child: Text(
                                                    (index2 + 1).toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(
                                                          appbar: false,
                                                          userID:
                                                              groupParticipant[
                                                                      index]
                                                                  .groupUsers![
                                                                      index2]
                                                                  .userID,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: CircleAvatar(
                                                    foregroundImage:
                                                        CachedNetworkImageProvider(
                                                      groupParticipant[index]
                                                          .groupUsers![index2]
                                                          .avatar!
                                                          .mediaURL
                                                          .minURL,
                                                    ),
                                                    radius: 18,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    groupParticipant[index]
                                                        .groupUsers![index2]
                                                        .displayName
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Text(
                                                  groupParticipant[index]
                                                      .groupUsers![index2]
                                                      .role
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
              userParticipant.isNotEmpty
                  ? SizedBox(
                      height: 350,
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: userParticipant.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: ARMOYU.appbarColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    child: CustomText.costum1(
                                        (index + 1).toString(),
                                        weight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                            appbar: false,
                                            userID:
                                                userParticipant[index].userID,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      foregroundImage:
                                          CachedNetworkImageProvider(
                                        userParticipant[index]
                                            .avatar!
                                            .mediaURL
                                            .minURL,
                                      ),
                                      radius: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomText.costum1(userParticipant[index]
                                      .displayName
                                      .toString()),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 1,
                        ),
                      ),
                    )
                  : Container(),
              widget.event.status == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.costum1(
                          "Etkinliğe katılım süresi sona erdi. Eğer bi yanlışlık olduğunu düşünüyorsanız lütfen yetkililer ile iletişime geçiniz. aramizdakioyuncu.com",
                          align: TextAlign.center,
                        ),
                      ],
                    )
                  : didijoin
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomButtons.costum1(
                                "VAZGEÇ",
                                onPressed: leaveevent,
                                loadingStatus: joineventProccess,
                              ),
                              const SizedBox(height: 20),
                              CustomText.costum1(
                                  "Etkinliğe zaten katıldınız vazgeçmek için en son süre etkinlikten 30 dakika öncedir.",
                                  align: TextAlign.center),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            CustomButtons.costum1(
                              "KATIL",
                              onPressed: joinevent,
                              loadingStatus: joineventProccess,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: rulesacception,
                                  onChanged: (value) {
                                    setState(() {
                                      rulesacception = !rulesacception;
                                    });
                                  },
                                ),
                                CustomText.costum1(
                                  "Kuralları okudum ve anladım kabul ediyorum.",
                                ),
                              ],
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
