import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/cards/cards_view.dart.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ARMOYUWidget {
  List<Map<String, String>> content;
  final bool firstFetch;

  ARMOYUWidget({
    required this.content,
    required this.firstFetch,
  });

  Widget widgetTPlist() {
    return CustomCards(
      firstFetch: firstFetch,
      title: "TP",
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
      {required Function accept, Function? decline, String? question}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          title: CustomText.costum1(QuestionKeys.areyousure.tr),
          content:
              CustomText.costum1(question ?? QuestionKeys.areyousuredetail.tr),
          actions: <Widget>[
            TextButton(
              child: CustomText.costum1(CommonKeys.cancel.tr),
              onPressed: () {
                if (decline != null) {
                  decline();
                }
                Get.back();
              },
            ),
            TextButton(
              child: CustomText.costum1(CommonKeys.accept.tr),
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
