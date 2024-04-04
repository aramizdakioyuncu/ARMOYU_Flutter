import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  static Widget costum1(String text,
      {required Function onPressed, required bool loadingStatus}) {
    Color? background = ARMOYU.buttonColor;
    Color foregroundColor = Colors.white;

    return loadingStatus
        ? CupertinoActivityIndicator(color: ARMOYU.color)
        : ElevatedButton(
            onPressed: () async {
              if (!loadingStatus) {
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
    required Icon icon,
    String? text,
    required onPressed,
  }) {
    List<Widget> aa = [icon];
    if (text != null) {
      aa.add(const SizedBox(width: 10));
      aa.add(Text(text));
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
