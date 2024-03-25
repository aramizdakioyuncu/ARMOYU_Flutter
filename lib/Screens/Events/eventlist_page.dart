import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/event.dart';
import 'package:ARMOYU/Models/event.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventlistPage extends StatefulWidget {
  const EventlistPage({super.key});

  @override
  State<EventlistPage> createState() => _EventlistPage();
}

List<Event> eventsList = [];
bool isfirstfetch = true;
bool eventlistProecces = false;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

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

    FunctionsEvent f = FunctionsEvent();
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
          eventsList.add(
            Event(
              eventID: element["event_ID"],
              status: element["event_status"],
              name: element["event_name"].toString(),
              eventType: element["event_type"].toString(),
              eventDate: element["event_date"].toString(),
              gameImage: element["event_gamelogo"],
              image: element["event_foto"].toString(),
              banner: element["event_gamebanner"],
              eventorganizer: User(
                displayName: element["event_organizername"],
                avatar: Media(
                  mediaURL: MediaURL(
                    bigURL: element["event_organizeravatar"],
                    normalURL: element["event_organizeravatar"],
                    minURL: element["event_organizeravatar"],
                  ),
                ),
              ),
              eventPlace: element["event_yer"].toString(),
              description: element["event_description"],
              rules: element["event_rules"],
              participantsLimit: element["event_participantlimit"],
              participantsCurrent: element["event_participantcurrent"],
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        appBar: AppBar(
          title: const Text('Etkinlikler'),
          backgroundColor: ARMOYU.appbarColor,
        ),
        body: eventsList.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: geteventslist,
                child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: eventsList.length,
                  itemBuilder: (context, index) {
                    Event aa = eventsList[index];
                    return aa.eventListWidget(context);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 1);
                  },
                ),
              ),
      ),
    );
  }
}
