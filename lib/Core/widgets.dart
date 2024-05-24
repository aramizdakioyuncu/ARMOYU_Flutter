import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/cards.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  static void toastNotification(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: ARMOYU.bodyColor,
      textColor: ARMOYU.color,
      fontSize: 14.0,
    );
  }

  static void showConfirmationDialog(BuildContext context,
      {required Function accept, Function? decline}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ARMOYU.backgroundcolor,
          title: CustomText.costum1('Emin misiniz?'),
          content: CustomText.costum1(
              'Bu işlemi gerçekleştirmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: CustomText.costum1('İptal'),
              onPressed: () {
                if (decline != null) {
                  decline();
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText.costum1('Onayla'),
              onPressed: () {
                accept();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
