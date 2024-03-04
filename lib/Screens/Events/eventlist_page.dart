// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/event.dart';
import 'package:ARMOYU/Models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventlistPage extends StatefulWidget {
  const EventlistPage({super.key});

  @override
  _EventlistPage createState() => _EventlistPage();
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
              eventID: element["etkinlik_ID"],
              eventName: element["etkinlik_adi"].toString(),
              eventType: element["etkinlik_tip"].toString(),
              eventDate: element["etkinlik_zaman"].toString(),
              eventimage: element["etkinlik_oyunlogo"],
              eventbanner: element["etkinlik_oyunbanner"],
              eventmanager: element["etkinlik_yetkili"],
              eventmanageravatar: element["etkinlik_yetkiliavatar"],
              eventPlace: element["etkinlik_yer"].toString(),
              description: element["etkinlik_aciklama"].toString(),
              rules: element["etkinlik_kural"].toString(),
              maxParticipants: element["etkinlik_katilimcilimit"] == 0
                  ? 100000
                  : element["etkinlik_katilimcilimit"],
              currentParticipants: element["etkinlik_katilimcimevcut"],
              location: 'etkinlik_konum',
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
                child: ListView.builder(
                  itemCount: eventsList.length,
                  itemBuilder: (context, index) {
                    Event aa = eventsList[index];
                    return aa.eventListWidget(context);
                  },
                ),
              ),
      ),
    );
  }
}
