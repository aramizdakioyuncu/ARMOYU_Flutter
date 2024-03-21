import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/cards.dart';
import 'package:flutter/material.dart';

class ARMOYUWidget {
  final ScrollController scrollController;
  List<Map<String, String>> content;
  final bool firstFetch;

  ARMOYUWidget({
    required this.scrollController,
    required this.content,
    required this.firstFetch,
  });

  Widget widgetTPlist() {
    return CustomCards(
      firstFetch: firstFetch,
      title: "TP",
      scrollController: scrollController,
      effectcolor: const Color.fromARGB(255, 10, 84, 175).withOpacity(0.7),
      content: content,
      icon: const Icon(
        Icons.auto_graph_outlined,
        size: 15,
        color: Colors.white,
      ),
    );
  }

  Widget widgetPOPlist() {
    return CustomCards(
      firstFetch: firstFetch,
      scrollController: scrollController,
      title: "POP",
      effectcolor: const Color.fromARGB(255, 175, 10, 10).withOpacity(0.7),
      content: content,
      icon: const Icon(
        Icons.remove_red_eye_outlined,
        size: 15,
        color: Colors.white,
      ),
    );
  }

  static void stackbarNotification(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ARMOYU.backgroundcolor,
        content: Text(
          text,
          style: TextStyle(color: ARMOYU.textColor),
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
