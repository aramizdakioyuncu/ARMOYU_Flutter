import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/event.dart';
import 'package:ARMOYU/Functions/page_functions.dart';
import 'package:ARMOYU/Models/ARMOYU/dlc.dart';
import 'package:ARMOYU/Models/ARMOYU/file.dart';
import 'package:ARMOYU/Models/ARMOYU/role.dart';
import 'package:ARMOYU/Models/event.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Group/group_page.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventPage extends StatefulWidget {
  final User? currentUser;

  final Event event;
  const EventPage({
    super.key,
    required this.currentUser,
    required this.event,
  });

  @override
  State<EventPage> createState() => _EventStatePage();
}

class _EventStatePage extends State<EventPage> {
  bool didijoin = false;

  bool _rulesacception = false;

  List<User> userParticipant = [];
  List<Group> groupParticipant = [];
  bool fetchParticipantProccess = false;
  bool fetcheventdetailProcess = false;

  List<DLCInfo> dlcList = [];
  List<FileInfo> fileList = [];
  List detailList = [];
  String? eventdetailImage;
  bool joineventProccess = false;

  String date = "";
  String time = "";
  @override
  void initState() {
    super.initState();

    List<String> datetime = widget.event.eventDate.split(' ');
    date = datetime[0];
    time = datetime[1];

    if (widget.event.participantgroupsList == null &&
        widget.event.participantpeopleList == null) {
      fetchparticipantList(widget.event.eventID);
    }

    fetcheventdetail(widget.event.eventID);
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  void onRefreshfunction() async {
    await fetchparticipantList(widget.event.eventID);
    fetcheventdetail(widget.event.eventID);
  }

  Future<void> fetcheventdetail(eventID) async {
    if (fetcheventdetailProcess) {
      return;
    }
    fetcheventdetailProcess = true;
    setstatefunction();

    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response = await f.detailfetch(eventID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      fetchParticipantProccess = false;
      setstatefunction();
      return;
    }

    dlcList.clear();
    for (var dlc in response["icerik"]["dlc"]) {
      dlcList.add(
        DLCInfo(
          dlcID: dlc["dlc_ID"],
          dlcname: dlc["dlc_name"],
          dlcFile: dlc["dlc_file"],
        ),
      );
    }

    fileList.clear();
    for (var files in response["icerik"]["files"]) {
      fileList.add(
        FileInfo(
          fileID: files["file_ID"],
          fileType: files["file_type"],
          fileName: files["file_name"],
          fileURL: files["file_URL"],
        ),
      );
    }

    detailList.clear();
    for (var detail in response["icerik"]["detail"]) {
      detail["detail_ID"];
      if (detail["detail_name"] == "cekicilogo") {
        eventdetailImage = detail["detail_info"];
      }
      detailList.add(
        {
          "name": detail["detail_name"],
          "info": detail["detail_info"],
        },
      );
    }
  }

  Future<void> fetchparticipantList(eventID) async {
    if (fetchParticipantProccess) {
      return;
    }
    fetchParticipantProccess = true;
    setstatefunction();
    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response = await f.participantList(eventID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      fetchParticipantProccess = false;
      setstatefunction();
      return;
    }

    userParticipant.clear();
    groupParticipant.clear();
    setstatefunction();

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
            role: Role(
                roleID: 0, name: element2["player_role"].toString(), color: ""),
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
      if (element["player_ID"] == ARMOYU.appUsers[ARMOYU.selectedUser].userID) {
        didijoin = true;
        setstatefunction();
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

    widget.event.participantpeopleList = userParticipant;
    widget.event.participantgroupsList = groupParticipant;

    fetchParticipantProccess = false;
    setstatefunction();
  }

  Future<void> joinevent() async {
    if (!_rulesacception) {
      String gelenyanit = "Kuralları kabul etmediniz!";
      ARMOYUWidget.stackbarNotification(context, gelenyanit);
      return;
    }

    joineventProccess = true;
    setstatefunction();

    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response =
        await f.joinOrleave(widget.event.eventID, true);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    await fetchparticipantList(widget.event.eventID);
    joineventProccess = false;
    setstatefunction();
  }

  Future<void> leaveevent() async {
    joineventProccess = true;
    setstatefunction();

    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response =
        await f.joinOrleave(widget.event.eventID, false);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    await fetchparticipantList(widget.event.eventID);

    didijoin = false;
    joineventProccess = false;
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: Text("${widget.event.name} Etkinliği"),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async => fetchparticipantList(widget.event.eventID),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (widget.event.image == null) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaViewer(
                        media: [
                          Media(
                            mediaID: 0,
                            mediaURL: MediaURL(
                              bigURL: widget.event.image.toString(),
                              normalURL: widget.event.image.toString(),
                              minURL: widget.event.image.toString(),
                            ),
                          ),
                        ],
                        initialIndex: 0,
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  height: ARMOYU.screenHeight / 4,
                  width: ARMOYU.screenWidth,
                  fit: widget.event.image != null
                      ? BoxFit.cover
                      : BoxFit.contain,
                  imageUrl: widget.event.image != null
                      ? widget.event.image.toString()
                      : widget.event.gameImage,
                  placeholder: (context, url) => const SizedBox(
                    height: 40,
                    width: 40,
                    child: CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      ErrorWidget("exception"),
                ),
              ),
              const SizedBox(height: 50),
              eventdetailImage != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: eventdetailImage!,
                        height: ARMOYU.screenWidth / 3,
                        width: ARMOYU.screenWidth / 3,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Container(),
              eventdetailImage != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaViewer(
                                media: [
                                  Media(
                                    mediaID: 0,
                                    mediaURL: MediaURL(
                                      bigURL:
                                          widget.event.detailImage.toString(),
                                      normalURL:
                                          widget.event.detailImage.toString(),
                                      minURL:
                                          widget.event.detailImage.toString(),
                                    ),
                                  ),
                                ],
                                initialIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.event.detailImage!,
                          height: ARMOYU.screenHeight / 4,
                          width: ARMOYU.screenWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Container(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(detailList.length, (index) {
                    if (detailList[index]["name"] == "cekici" ||
                        detailList[index]["name"] == "Konvamiri" ||
                        detailList[index]["name"] == "cekicilogo") {
                      return Container();
                    }

                    FaIcon detailIcon = const FaIcon(FontAwesomeIcons.road);
                    if (detailList[index]["name"] == "yol") {
                      detailIcon = const FaIcon(FontAwesomeIcons.road);
                    }
                    if (detailList[index]["name"] == "sunucu") {
                      detailIcon = const FaIcon(FontAwesomeIcons.globe);
                    }
                    if (detailList[index]["name"] == "yolculuk") {
                      detailIcon = const FaIcon(FontAwesomeIcons.signsPost);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          detailIcon,
                          CustomText.costum1(
                            detailList[index]["info"],
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(width: 5),
                    CustomText.costum1(
                      date,
                      weight: FontWeight.bold,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.alarm),
                    const SizedBox(width: 5),
                    CustomText.costum1(
                      time,
                      weight: FontWeight.bold,
                      size: 20,
                    ),
                  ],
                ),
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
                            InkWell(
                              onTap: () {
                                PageFunctions.pushProfilePage(
                                  context,
                                  User(
                                    userID: widget
                                        .event.eventorganizer[index].userID,
                                  ),
                                  ScrollController(),
                                );
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.event.eventorganizer[index]
                                      .avatar!.mediaURL.minURL,
                                  fit: BoxFit.cover,
                                  height: ARMOYU.screenWidth / 5,
                                  width: ARMOYU.screenWidth / 5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomText.costum1(widget
                                .event.eventorganizer[index].displayName!),
                            CustomText.costum1("Yetkili"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomText.costum1(
                      "Kurallar",
                      size: 22,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText.costum1(widget.event.rules),
                    const SizedBox(height: 10),
                    CustomText.costum1(
                      "Açıklama",
                      size: 22,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText.costum1(widget.event.description),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              !fetchParticipantProccess
                  ? Column(
                      children: [
                        Visibility(
                          visible:
                              widget.event.participantgroupsList!.isNotEmpty,
                          child: SizedBox(
                            height: 600,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 5),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.event.participantgroupsList!.length,
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
                                              widget
                                                  .event
                                                  .participantgroupsList![index]
                                                  .groupBanner!
                                                  .mediaURL
                                                  .minURL,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 20),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (content) =>
                                                        GroupPage(
                                                      currentUser:
                                                          widget.currentUser,
                                                      groupID: widget
                                                          .event
                                                          .participantgroupsList![
                                                              index]
                                                          .groupID!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundImage:
                                                    CachedNetworkImageProvider(
                                                  widget
                                                      .event
                                                      .participantgroupsList![
                                                          index]
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
                                              child: CustomText.costum1(
                                                  widget
                                                      .event
                                                      .participantgroupsList![
                                                          index]
                                                      .groupName
                                                      .toString(),
                                                  weight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.black54,
                                                  ),
                                                  child: CustomText.costum1(
                                                    widget
                                                        .event
                                                        .participantgroupsList![
                                                            index]
                                                        .groupshortName
                                                        .toString(),
                                                    weight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.black54,
                                                  ),
                                                  child: CustomText.costum1(
                                                    "${widget.event.participantgroupsList![index].groupUsers!.length}/${widget.event.participantsgroupplayerlimit}",
                                                    weight: FontWeight.bold,
                                                    color: Colors.white,
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
                                              widget
                                                  .event
                                                  .participantgroupsList![index]
                                                  .groupUsers!
                                                  .length,
                                              (index2) => Container(
                                                width: ARMOYU.screenWidth - 50,
                                                alignment: Alignment.bottomLeft,
                                                decoration: index2 == 0
                                                    ? const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.yellow,
                                                          ],
                                                        ),
                                                      )
                                                    : const BoxDecoration(),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        child: Text(
                                                          (index2 + 1)
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      InkWell(
                                                        onTap: () {
                                                          PageFunctions
                                                              .pushProfilePage(
                                                            context,
                                                            User(
                                                              userID: groupParticipant[
                                                                      index]
                                                                  .groupUsers![
                                                                      index2]
                                                                  .userID,
                                                            ),
                                                            ScrollController(),
                                                          );
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          foregroundImage:
                                                              CachedNetworkImageProvider(
                                                            widget
                                                                .event
                                                                .participantgroupsList![
                                                                    index]
                                                                .groupUsers![
                                                                    index2]
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
                                                          widget
                                                              .event
                                                              .participantgroupsList![
                                                                  index]
                                                              .groupUsers![
                                                                  index2]
                                                              .displayName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                      Text(
                                                        widget
                                                            .event
                                                            .participantgroupsList![
                                                                index]
                                                            .groupUsers![index2]
                                                            .role!
                                                            .name,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
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
                          ),
                        ),
                        Visibility(
                          visible:
                              widget.event.participantpeopleList!.isNotEmpty,
                          child: SizedBox(
                            height: 350,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  widget.event.participantpeopleList!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CustomText.costum1(
                                          "${index + 1}.",
                                          weight: FontWeight.bold,
                                          align: TextAlign.center,
                                          size: 14,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                          widget
                                              .event
                                              .participantpeopleList![index]
                                              .avatar!
                                              .mediaURL
                                              .minURL,
                                        ),
                                        radius: 14,
                                      ),
                                    ],
                                  ),
                                  title: CustomText.costum1(
                                    widget.event.participantpeopleList![index]
                                        .displayName
                                        .toString(),
                                  ),
                                  onTap: () {
                                    PageFunctions.pushProfilePage(
                                      context,
                                      User(
                                        userID: widget
                                            .event
                                            .participantpeopleList![index]
                                            .userID,
                                      ),
                                      ScrollController(),
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 350,
                      child: CupertinoActivityIndicator(),
                    ),
              Visibility(
                visible: widget.event.status != 0 && !fetchParticipantProccess,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: didijoin,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomText.costum1(
                                "Etkinliğe zaten katıldınız.Vazgeçmek için en son süre etkinlikten 30 dakika öncedir.",
                                align: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              CustomButtons.costum1(
                                text: "VAZGEÇ",
                                onPressed: leaveevent,
                                loadingStatus: joineventProccess,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !didijoin,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rulesacception,
                                    onChanged: (value) {
                                      _rulesacception = !_rulesacception;
                                      setstatefunction();
                                    },
                                  ),
                                  CustomText.costum1(
                                    "Kuralları okudum ve anladım kabul ediyorum.",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CustomButtons.costum1(
                                text: "KATIL",
                                onPressed: joinevent,
                                enabled: _rulesacception,
                                loadingStatus: joineventProccess,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.event.status == 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText.costum1(
                        "Etkinliğe katılım süresi sona erdi. Eğer bi yanlışlık olduğunu düşünüyorsanız lütfen yetkililer ile iletişime geçiniz. aramizdakioyuncu.com",
                        align: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
