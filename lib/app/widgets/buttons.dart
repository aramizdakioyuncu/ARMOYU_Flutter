import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtons {
  static Widget friendbuttons(String text, onPressed, Color color) {
    Color background = color;
    Color foregroundColor = Colors.white;
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: background, // Arka plan rengini belirleyin
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Kenar yarıçapını ayarlayın
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  static Widget costum1({
    required String text,
    Color? background,
    required Function onPressed,
    required Rx<bool> loadingStatus,
    bool enabled = true,
  }) {
    Color foregroundColor = Colors.white;

    return loadingStatus.value
        ? const CupertinoActivityIndicator()
        : ElevatedButton(
            onPressed: !enabled
                ? null
                : () async {
                    if (!loadingStatus.value) {
                      await onPressed();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: background, // Arka plan rengini belirleyin
              foregroundColor: foregroundColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Kenar yarıçapını ayarlayın
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
  }

  static Widget costum2({
    Icon? icon,
    String? text,
    Color? background,
    required onPressed,
    bool loadingStatus = false,
    bool enabled = true,
  }) {
    // background = ARMOYU.buttonColor;

    List<Widget> aa = [];

    if (icon != null) {
      aa.add(icon);
    }
    if (text != null) {
      aa.add(const SizedBox(width: 6));
      aa.add(Text(text));
    }
    return loadingStatus
        ? const CupertinoActivityIndicator()
        : ElevatedButton(
            onPressed: !enabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: enabled
                  ? Get.theme.highlightColor.withValues(alpha: 0.3)
                  : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: aa,
            ),
          );
  }
}
