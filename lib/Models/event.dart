import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Events/event_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Event {
  int eventID;
  String name;
  String eventType;
  String eventDate;
  String gameImage;
  String image;
  String banner;
  String eventmanager;
  String eventmanageravatar;
  String eventPlace;
  String description;
  String rules;
  int maxParticipants;
  int currentParticipants;
  String location;

  Event({
    required this.eventID,
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.gameImage,
    required this.image,
    required this.banner,
    required this.eventmanager,
    required this.eventmanageravatar,
    required this.eventPlace,
    required this.description,
    required this.rules,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.location,
  });

  Widget eventListWidget(context) {
    Color participantsColor = Colors.red;
    if (currentParticipants / maxParticipants < 0.75) {
      participantsColor = Colors.orange;
    }
    if (currentParticipants / maxParticipants < 0.50) {
      participantsColor = Colors.yellow;
    }
    if (currentParticipants / maxParticipants < 0.25) {
      participantsColor = Colors.green;
    }

    return Container(
      width: ARMOYU.screenWidth,
      padding: const EdgeInsets.all(2),
      child: Material(
        color: ARMOYU.appbarColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(event: this),
              ),
            );
          },
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  SizedBox(
                    width: ARMOYU.screenWidth / 5,
                    height: ARMOYU.screenWidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: banner,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.car_crash,
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
                                    name,
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
                                      value:
                                          currentParticipants / maxParticipants,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("$currentParticipants/$maxParticipants"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.date_range, size: 12),
                                  Text(
                                    eventDate,
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
                  // const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
