import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
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
  State<EventPage> createState() => _EventStatePage();
}

class _EventStatePage extends State<EventPage> {
  bool rulesacception = false;
  List<Event> eventsList = [];
  bool joineventProccess = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> joinevent() async {
    if (!rulesacception) {
      String gelenyanit = "Kuralları kabul etmediniz!";
      ARMOYUWidget.stackbarNotification(context, gelenyanit);
      return;
    }

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
                CachedNetworkImage(
                  imageUrl: widget.event.image,
                  placeholder: (context, url) => const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      ErrorWidget("exception"),
                  fit: BoxFit.cover,
                  width: ARMOYU.screenWidth,
                ),
                const SizedBox(height: 50),
                const Text("Son Katılım Tarihi"),
                Text(
                  widget.event.eventDate,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23),
                ),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.event.eventmanageravatar,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Yetkili"),
                const SizedBox(height: 10),
                const Text(
                  "Kurallar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(widget.event.rules),
                const SizedBox(height: 10),
                const Text(
                  "Açıklama",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(widget.event.description),
                const SizedBox(height: 10),
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
                    const Text("Kuralları okudum ve anladım kabul ediyorum."),
                  ],
                ),
                CustomButtons.costum1("KATIL", joinevent, joineventProccess),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
