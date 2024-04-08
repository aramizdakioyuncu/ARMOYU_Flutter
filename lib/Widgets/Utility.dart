import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WidgetUtility {
  static Widget specialText(
    BuildContext context,
    String text, {
    TextAlign textAlign = TextAlign.start,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    final lines = text.split('\n');
    final textSpans = <TextSpan>[];

    for (String line in lines) {
      final words = line.split(' ');
      final lineSpans = <TextSpan>[];

      for (int i = 0; i < words.length; i++) {
        final word = words[i];

        if (word.isNotEmpty) {
          if (word.startsWith('#')) {
            final trimmedWord = word.trim();
            lineSpans.add(TextSpan(
              text: trimmedWord,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Burada # işaretine tıklandığında yapılacak işlemi ekleyin
                  log('Tapped on hashtag: $trimmedWord');
                },
            ));
          } else if (word.startsWith('@')) {
            final username = word.trim(); // @ işaretini kaldır ve trim yap
            lineSpans.add(TextSpan(
              text: username,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Burada @ işaretine tıklandığında yapılacak işlemi ekleyin
                  log('Tapped on username: $username');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          username: username.substring(1), appbar: true),
                    ),
                  );
                },
            ));
          } else {
            lineSpans.add(TextSpan(
              text: word,
              style: TextStyle(color: color),
            ));
          }

          if (i < words.length - 1) {
            lineSpans.add(const TextSpan(text: ' '));
          }
        }
      }

      textSpans.add(TextSpan(children: lineSpans));
      textSpans.add(const TextSpan(text: '\n'));
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: TextStyle(
          fontWeight: fontWeight,
        ),
      ),
      textAlign: textAlign,
    );
  }

  static Future cupertinoDatePicker({
    required context,
    required Function(String) onChanged,
    required Function setstatefunction,
  }) {
    String selectedYear = "2000";
    String selectedMonth = "1";
    String selectedDay = "1";

    return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        List<Map<int, String>> yearList = List.generate(
          DateTime.now().year - 1999,
          (index) => {2000 + index: (2000 + index).toString()},
        );
        List<Map<int, String>> monthList = [
          {1: "Ocak"},
          {2: "Şubat"},
          {3: "Mart"},
          {4: "Nisan"},
          {5: "Mayıs"},
          {6: "Haziran"},
          {7: "Temmuz"},
          {8: "Ağustos"},
          {9: "Eylül"},
          {10: "Ekim"},
          {11: "Kasım"},
          {12: "Aralık"},
        ];

        List<Map<int, String>> dayList =
            List.generate(31, (index) => {index + 1: (index + 1).toString()});

        if (selectedDay.length == 1) {
          selectedDay = "0$selectedDay";
        }
        if (selectedMonth.length == 1) {
          selectedMonth = "0$selectedMonth";
        }
        String selectedDate = "$selectedDay.$selectedMonth.$selectedYear";

        return Container(
          height: 250,
          width: ARMOYU.screenWidth,
          color: ARMOYU.backgroundcolor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    onChanged(selectedDate);
                    setstatefunction();
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Bitti",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: ARMOYU.screenWidth / 3,
                    height: 200,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      children: List.generate(
                        yearList.length,
                        (index) {
                          Map<int, String> yearMap = yearList[index];
                          return Text(yearMap.values.last.toString());
                        },
                      ),
                      onSelectedItemChanged: (value) {
                        selectedYear = yearList[value].values.first;
                      },
                    ),
                  ),
                  SizedBox(
                    width: ARMOYU.screenWidth / 3,
                    height: 150,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      children: List.generate(monthList.length, (index) {
                        Map<int, String> monthMap = monthList[index];
                        return Text(monthMap.values.last.toString());
                      }),
                      onSelectedItemChanged: (value) {
                        Map<int, String> monthMap = monthList[value];
                        selectedMonth = monthMap.keys.first.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    width: ARMOYU.screenWidth / 3,
                    height: 150,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      children: List.generate(
                        dayList.length,
                        (index) {
                          Map<int, String> dayMap = dayList[index];
                          return Text(dayMap.values.last.toString());
                        },
                      ),
                      onSelectedItemChanged: (value) {
                        Map<int, String> dayMap = dayList[value];
                        selectedDay = dayMap.keys.first.toString();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //CupertioTimeSelector
  static Future cupertinoTimepicker({
    required context,
    required Function(String) onChanged,
    required Function setstatefunction,
  }) {
    String hour = "00";
    String minute = "00";

    return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        List<Map<int, String>> hourList =
            List.generate(24, (index) => {index: (index).toString()});

        List<Map<int, String>> minuteList =
            List.generate(60, (index) => {index: (index).toString()});

        if (hour.length == 1) {
          hour = "0$hour";
        }
        if (minute.length == 1) {
          minute = "0$minute";
        }
        String selectedTime = "$hour:$minute";

        return Container(
          height: 250,
          width: ARMOYU.screenWidth,
          color: ARMOYU.backgroundcolor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    onChanged(selectedTime);
                    setstatefunction();
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Bitti",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: ARMOYU.screenWidth / 2,
                    height: 200,
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 32,
                      children: List.generate(
                        hourList.length,
                        (index) {
                          Map<int, String> hourMap = hourList[index];
                          if (hourMap.values.last.length == 1) {
                            return Text("0${hourMap.values.last.toString()}");
                          } else {
                            return Text(hourMap.values.last.toString());
                          }
                        },
                      ),
                      onSelectedItemChanged: (value) {
                        hour = hourList[value].values.first;
                      },
                    ),
                  ),
                  SizedBox(
                    width: ARMOYU.screenWidth / 2,
                    height: 150,
                    child: CupertinoPicker(
                      looping: true,
                      itemExtent: 32,
                      children: List.generate(minuteList.length, (index) {
                        Map<int, String> monthMap = minuteList[index];

                        if (monthMap.values.last.length == 1) {
                          return Text("0${monthMap.values.last.toString()}");
                        } else {
                          return Text(monthMap.values.last.toString());
                        }
                      }),
                      onSelectedItemChanged: (value) {
                        minute = minuteList[value].values.first;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
