import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/cards.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ARMOYUWidget {
  final UserAccounts currentUserAccounts;

  final ScrollController scrollController;
  List<Map<String, String>> content;
  final bool firstFetch;

  ARMOYUWidget({
    required this.scrollController,
    required this.content,
    required this.firstFetch,
    required this.currentUserAccounts,
  });

  Widget widgetTPlist() {
    return CustomCards(
      currentUserAccounts: currentUserAccounts,
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
      currentUserAccounts: currentUserAccounts,
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
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        content: Text(text),
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
      fontSize: 14.0,
    );
  }

  static void showConfirmationDialog(BuildContext context,
      {required Function accept, Function? decline}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
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
                Get.back();
              },
            ),
            TextButton(
              child: CustomText.costum1('Onayla'),
              onPressed: () {
                accept();

                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
