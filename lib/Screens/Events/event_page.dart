// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/event.dart';
import 'package:ARMOYU/Models/event.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({
    super.key,
    required this.event,
  });
  final Event event;
  @override
  _EventStatePage createState() => _EventStatePage();
}

class _EventStatePage extends State<EventPage> {
  List<Event> eventsList = [];
  bool joineventProccess = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> joinevent() async {
    joineventProccess = true;
    FunctionsEvent f = FunctionsEvent();
    Map<String, dynamic> response = await f.fetch();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    eventsList.clear();
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CachedNetworkImage(imageUrl: widget.event.eventbanner),
                    const Spacer(),
                    Text(widget.event.eventDate),
                    const Spacer(),
                    CachedNetworkImage(imageUrl: widget.event.eventbanner),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(widget.event.rules),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Text(widget.event.description),
                    CustomButtons()
                        .Costum1("KATIL", joinevent, joineventProccess),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
