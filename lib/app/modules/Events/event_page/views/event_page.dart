import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Events/event_page/controllers/event_controller.dart';
import 'package:ARMOYU/app/modules/Utility/newphotoviewer.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EventPage extends StatelessWidget {
  final UserAccounts currentUserAccounts;

  const EventPage({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventController(
      currentUserAccounts: currentUserAccounts,
    ));
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("${controller.event.value!.name} Etkinliği"),
        // backgroundColor: ARMOYU.appbarColor,
      ),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller
                  .fetchparticipantList(controller.event.value!.eventID);
            },
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => InkWell(
                onTap: () {
                  if (controller.event.value!.image == null) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaViewer(
                        currentUser: currentUserAccounts.user,
                        media: [
                          Media(
                            mediaID: 0,
                            mediaURL: MediaURL(
                              bigURL: controller.event.value!.image.toString(),
                              normalURL:
                                  controller.event.value!.image.toString(),
                              minURL: controller.event.value!.image.toString(),
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
                  fit: controller.event.value!.image != null
                      ? BoxFit.cover
                      : BoxFit.contain,
                  imageUrl: controller.event.value!.image != null
                      ? controller.event.value!.image.toString()
                      : controller.event.value!.gameImage!,
                  placeholder: (context, url) => const SizedBox(
                    height: 40,
                    width: 40,
                    child: CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      ErrorWidget("exception"),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => controller.eventdetailImage.value != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: controller.eventdetailImage.value!,
                        height: ARMOYU.screenWidth / 3,
                        width: ARMOYU.screenWidth / 3,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Container(),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => controller.eventdetailImage.value != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaViewer(
                                currentUser: currentUserAccounts.user,
                                media: [
                                  Media(
                                    mediaID: 0,
                                    mediaURL: MediaURL(
                                      bigURL: controller
                                          .event.value!.detailImage
                                          .toString(),
                                      normalURL: controller
                                          .event.value!.detailImage
                                          .toString(),
                                      minURL: controller
                                          .event.value!.detailImage
                                          .toString(),
                                    ),
                                  ),
                                ],
                                initialIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: controller.event.value!.detailImage!,
                          height: ARMOYU.screenHeight / 4,
                          width: ARMOYU.screenWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      List.generate(controller.detailList.length, (index) {
                    if (controller.detailList[index]["name"] == "cekici" ||
                        controller.detailList[index]["name"] == "Konvamiri" ||
                        controller.detailList[index]["name"] == "cekicilogo") {
                      return Container();
                    }

                    FaIcon detailIcon = const FaIcon(FontAwesomeIcons.road);
                    if (controller.detailList[index]["name"] == "yol") {
                      detailIcon = const FaIcon(FontAwesomeIcons.road);
                    }
                    if (controller.detailList[index]["name"] == "sunucu") {
                      detailIcon = const FaIcon(FontAwesomeIcons.globe);
                    }
                    if (controller.detailList[index]["name"] == "yolculuk") {
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
                            controller.detailList[index]["info"],
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 5),
                        CustomText.costum1(
                          controller.date.value,
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
                          controller.time.value,
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
                      itemCount: controller.event.value!.eventorganizer!.length,
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
                                    PageFunctions functions = PageFunctions(
                                      currentUserAccounts: currentUserAccounts,
                                    );
                                    functions.pushProfilePage(
                                      context,
                                      User(
                                        userID: controller.event.value!
                                            .eventorganizer![index].userID,
                                      ),
                                      ScrollController(),
                                    );
                                  },
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .event
                                          .value!
                                          .eventorganizer![index]
                                          .avatar!
                                          .mediaURL
                                          .minURL,
                                      fit: BoxFit.cover,
                                      height: ARMOYU.screenWidth / 5,
                                      width: ARMOYU.screenWidth / 5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                CustomText.costum1(controller.event.value!
                                    .eventorganizer![index].displayName!),
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
                        CustomText.costum1(
                            controller.event.value!.rules.toString()),
                        const SizedBox(height: 10),
                        CustomText.costum1(
                          "Açıklama",
                          size: 22,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        CustomText.costum1(
                            controller.event.value!.description.toString()),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => !controller.fetchParticipantProccess.value
                  ? Column(
                      children: [
                        Visibility(
                          visible: controller
                              .event.value!.participantgroupsList!.isNotEmpty,
                          child: SizedBox(
                            height: 600,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 5),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller
                                  .event.value!.participantgroupsList!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: ARMOYU.screenWidth - 30,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 190,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              controller
                                                  .event
                                                  .value!
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
                                                Get.toNamed("group/detail",
                                                    arguments: {
                                                      "user":
                                                          currentUserAccounts
                                                              .user,
                                                      "group": Group(
                                                        groupID: controller
                                                            .event
                                                            .value!
                                                            .participantgroupsList![
                                                                index]
                                                            .groupID!,
                                                      )
                                                    });
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (content) =>
                                                //         GroupPage(
                                                //       currentUserAccounts: widget
                                                //           .currentUserAccounts,
                                                //       groupID: widget
                                                //           .event
                                                //           .participantgroupsList![
                                                //               index]
                                                //           .groupID!,
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundImage:
                                                    CachedNetworkImageProvider(
                                                  controller
                                                      .event
                                                      .value!
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
                                                  controller
                                                      .event
                                                      .value!
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
                                                    controller
                                                        .event
                                                        .value!
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
                                                    "${controller.event.value!.participantgroupsList![index].groupUsers!.length}/${controller.event.value!.participantsgroupplayerlimit}",
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
                                              controller
                                                  .event
                                                  .value!
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
                                                              functions =
                                                              PageFunctions(
                                                            currentUserAccounts:
                                                                currentUserAccounts,
                                                          );

                                                          functions
                                                              .pushProfilePage(
                                                            context,
                                                            User(
                                                              userID: controller
                                                                  .groupParticipant[
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
                                                            controller
                                                                .event
                                                                .value!
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
                                                          controller
                                                              .event
                                                              .value!
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
                                                        controller
                                                            .event
                                                            .value!
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
                          visible: controller
                              .event.value!.participantpeopleList!.isNotEmpty,
                          child: SizedBox(
                            height: 350,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: controller
                                  .event.value!.participantpeopleList!.length,
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
                                          controller
                                              .event
                                              .value!
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
                                    controller
                                        .event
                                        .value!
                                        .participantpeopleList![index]
                                        .displayName
                                        .toString(),
                                  ),
                                  onTap: () {
                                    PageFunctions functions = PageFunctions(
                                      currentUserAccounts: currentUserAccounts,
                                    );

                                    functions.pushProfilePage(
                                      context,
                                      User(
                                        userID: controller
                                            .event
                                            .value!
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
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => Visibility(
                visible: controller.event.value!.status != 0 &&
                    !controller.fetchParticipantProccess.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: controller.didijoin.value,
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
                                onPressed: controller.leaveevent,
                                loadingStatus:
                                    controller.joineventProccess.value,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !controller.didijoin.value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: controller.rulesacception.value,
                                    onChanged: (value) {
                                      controller.rulesacception.value =
                                          !controller.rulesacception.value;
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
                                onPressed: controller.joinevent,
                                enabled: controller.rulesacception.value,
                                loadingStatus:
                                    controller.joineventProccess.value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => Visibility(
                visible: controller.event.value!.status == 0,
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
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          )
        ],
      ),
    );
  }
}
