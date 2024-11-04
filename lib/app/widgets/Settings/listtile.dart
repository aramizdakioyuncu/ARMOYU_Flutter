import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetSettings {
  final String listtileTitle;
  RxString? tralingText;
  final IconData listtileIcon;
  final dynamic onTap;

  WidgetSettings({
    required this.listtileTitle,
    this.tralingText,
    required this.listtileIcon,
    required this.onTap,
  });

  Widget listtile(context) {
    return ListTile(
      leading: Icon(listtileIcon),
      title: CustomText.costum1(listtileTitle),
      tileColor: Get.theme.scaffoldBackgroundColor,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(tralingText != null ? tralingText.toString() : ""),
          ),
          const Icon(Icons.arrow_forward_ios_outlined, size: 17),
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
