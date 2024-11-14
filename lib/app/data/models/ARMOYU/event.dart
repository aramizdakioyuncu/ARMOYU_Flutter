import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Event {
  int eventID;
  String? name;
  int? status;
  String? eventType;
  String? eventDate;
  String? gameImage;
  String? image;
  String? detailImage;
  String? banner;
  List<User>? eventorganizer;
  String? eventPlace;
  String? description;
  String? rules;
  int? participantsLimit;
  int? participantsCurrent;
  int? participantsgroupplayerlimit;
  String? location;

  List<Group>? participantgroupsList;
  List<User>? participantpeopleList;

  Event({
    required this.eventID,
    this.status,
    this.name,
    this.eventType,
    this.eventDate,
    this.gameImage,
    this.image,
    this.detailImage,
    this.banner,
    this.eventorganizer,
    this.eventPlace,
    this.description,
    this.rules,
    this.participantsLimit,
    this.participantsCurrent,
    this.participantsgroupplayerlimit,
    this.location,
  });

  Widget eventListWidget(context, {required User currentUser}) {
    Color participantsColor = Colors.red;
    if (participantsCurrent! / participantsLimit! < 0.75) {
      participantsColor = Colors.orange;
    }
    if (participantsCurrent! / participantsLimit! < 0.50) {
      participantsColor = Colors.yellow;
    }
    if (participantsCurrent! / participantsLimit! < 0.25) {
      participantsColor = Colors.green;
    }

    return SizedBox(
      width: ARMOYU.screenWidth,
      child: Material(
        color: Get.theme.cardColor,
        child: InkWell(
          onTap: () {
            Get.toNamed(
              "/event/detail",
              arguments: {
                "event": this,
              },
            );
          },
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  SizedBox(
                    width: ARMOYU.screenWidth / 5,
                    height: ARMOYU.screenWidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: banner!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: banner!,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.error,
                              size: 50,
                            ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Color.fromARGB(255, 48, 48, 48), // Çizginin rengi
                    thickness: 1, // Çizginin kalınlığı
                    width: 0, // Çizginin genişliği
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection:
                                    Axis.horizontal, // Yatay kaydırma için
                                child: SizedBox(
                                  width: ARMOYU.screenWidth / 2,
                                  child: Text(
                                    name!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: ARMOYU.screenWidth / 2.5,
                                    child: LinearProgressIndicator(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      minHeight: 10,
                                      color: participantsColor,
                                      value: participantsLimit == 0
                                          ? 0
                                          : participantsCurrent! /
                                              participantsLimit!,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  participantsLimit == 0
                                      ? Text("$participantsCurrent/∞")
                                      : Text(
                                          "$participantsCurrent/$participantsLimit"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.date_range, size: 12),
                                  const SizedBox(width: 5),
                                  Text(
                                    eventDate.toString(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
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
    );
  }
}
