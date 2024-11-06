import 'dart:developer';

import 'package:ARMOYU/app/functions/API_Functions/event.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/event.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventlistPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;

  const EventlistPage({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  State<EventlistPage> createState() => _EventlistPage();
}

List<Event> eventsList = [];
bool isfirstfetch = true;
bool eventlistProecces = false;

class _EventlistPage extends State<EventlistPage>
    with AutomaticKeepAliveClientMixin<EventlistPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (isfirstfetch) {
      geteventslist();
    }
  }

  Future<void> geteventslist() async {
    if (eventlistProecces) {
      return;
    }

    eventlistProecces = true;

    FunctionsEvent f = FunctionsEvent(
      currentUser: widget.currentUserAccounts.user,
    );
    Map<String, dynamic> response = await f.fetch();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      eventlistProecces = false;
      return;
    }

    eventsList.clear();
    for (dynamic element in response['icerik']) {
      if (mounted) {
        setState(() {
          List<User> aa = [];

          for (dynamic element2 in element['event_organizer']) {
            aa.add(
              User(
                userID: element2["player_ID"],
                displayName: element2["player_displayname"],
                avatar: Media(
                  mediaID: element2["player_ID"],
                  mediaURL: MediaURL(
                    bigURL: Rx<String>(element2["player_avatar"]),
                    normalURL: Rx<String>(element2["player_avatar"]),
                    minURL: Rx<String>(element2["player_avatar"]),
                  ),
                ),
              ),
            );
          }

          eventsList.add(
            Event(
              eventID: element["event_ID"],
              status: element["event_status"],
              name: element["event_name"],
              eventType: element["event_type"],
              eventDate: element["event_date"],
              gameImage: element["event_gamelogo"],
              image: element["event_foto"],
              detailImage: element["event_fotodetail"],
              banner: element["event_gamebanner"],
              eventorganizer: aa,
              eventPlace: element["event_location"],
              description: element["event_description"],
              rules: element["event_rules"],
              participantsLimit: element["event_participantlimit"],
              participantsCurrent: element["event_participantcurrent"],
              participantsgroupplayerlimit:
                  element["event_participantgroupplayerlimit"],
              location: element["event_location"],
            ),
          );
        });
      }
    }

    eventlistProecces = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlikler'),
      ),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await geteventslist();
            },
          ),
          eventsList.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: eventsList[index].eventListWidget(
                          context,
                          currentUserAccounts: widget.currentUserAccounts,
                        ),
                      );
                    },
                    childCount: eventsList.length,
                  ),
                ),
        ],
      ),
    );
  }
}
