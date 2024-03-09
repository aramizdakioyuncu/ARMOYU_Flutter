import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomNotifications {
  static void stackbarNotification(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ARMOYU.bacgroundcolor,
        content: Text(
          text,
          style: TextStyle(color: ARMOYU.textColor),
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
