import 'dart:developer';

import 'package:armoyu/app/core/widgets.dart';
import 'package:armoyu_widgets/data/models/select.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetUtility {
  static Widget specialText(
    BuildContext context,
    String text, {
    TextAlign textAlign = TextAlign.start,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    final lines = text.split('\n');
    final textSpans = <TextSpan>[];

    // URL tespiti için bir düzenli ifade (regex)
    final urlRegex = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

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
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Burada @ işaretine tıklandığında yapılacak işlemi ekleyin
                  log('Tapped on username: $username');
                  PageFunctions functions = PageFunctions();

                  functions.pushProfilePage(
                    context,
                    User(userName: username.substring(1).obs),
                  );
                },
            ));
          } else if (urlRegex.hasMatch(word)) {
            final match = urlRegex.firstMatch(word);
            final url = match?.group(0) ?? word;

            lineSpans.add(TextSpan(
              text: url,
              style: const TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  ARMOYUWidget.showConfirmationDialog(context,
                      question:
                          "Bu bağlantı uygulama dışına yönlendiriyor. Güvenliğiniz için, tıklamadan önce bağlantının güvenilir olduğundan emin olun.",
                      accept: () async {
                    if (!url.startsWith('http')) {
                      await launchUrl(Uri.parse('https://$url'));
                    } else {
                      await launchUrl(Uri.parse(url));
                    }
                  });
                },
            ));
          } else {
            lineSpans.add(
              TextSpan(
                text: word,
                style: TextStyle(color: color),
              ),
            );
          }

          if (i < words.length - 1) {
            lineSpans.add(const TextSpan(text: ' '));
          }
        }
      }

      textSpans.add(TextSpan(children: lineSpans));
      textSpans.add(const TextSpan(text: '\n'));
    }

    // return Text("data");
    return RichText(
      text: TextSpan(
        children: textSpans,
        style: TextStyle(fontWeight: fontWeight, color: Get.theme.primaryColor),
      ),
      textAlign: textAlign,
    );
  }

  static Future cupertinoDatePicker({
    required BuildContext context,
    required Function(String) onChanged,
    bool dontallowPastDate = false,
    int yearCount = 65,
  }) {
    var startYearDate = 1945.obs;
    var startMonthDate = 1.obs;
    var startDayDate = 1.obs;

    if (dontallowPastDate) {
      startYearDate.value = DateTime.now().year;
      startMonthDate.value = DateTime.now().month;
      startDayDate.value = DateTime.now().day;
    }

    var selectedYear = startYearDate.value.toString().obs;
    var selectedMonth = startMonthDate.value.toString().obs;
    var selectedDay = startDayDate.value.toString().obs;

    var yearList = List.generate(
      yearCount,
      (index) => {
        startYearDate.value + index: (startYearDate.value + index).toString()
      },
    ).obs;
    var monthList = <Map<int, String>>[
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
    ].obs;

    var monthEditiableList = <Map<int, String>>[
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
    ].obs;

    var dayList =
        List.generate(31, (index) => {index + 1: (index + 1).toString()}).obs;

    var editibledayList =
        List.generate(31, (index) => {index + 1: (index + 1).toString()}).obs;

    updatemonthdonwallowpastdate() {
      if (dontallowPastDate) {
        //Geçmişteki Ayları siler
        monthEditiableList.value = monthList.where((month) {
          return month.keys.first >= int.parse(selectedMonth.value);
        }).toList();
      } else {
        monthEditiableList.value = monthList.toList();
      }
    }

    void removeDaysAfter() {
      if (dontallowPastDate &&
          selectedMonth.value == startMonthDate.value.toString()) {
        editibledayList.value = dayList.where((day) {
          return day.keys.first >= int.parse(selectedDay.value);
        }).toList();
      } else {
        editibledayList.value = dayList.toList();
      }
    }

    updatemonthdonwallowpastdate();
    removeDaysAfter();

    return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (selectedDay.value.length == 1) {
          selectedDay.value = "0$selectedDay";
        }
        if (selectedMonth.value.length == 1) {
          selectedMonth.value = "0$selectedMonth";
        }
        var selectedDate = "$selectedDay.$selectedMonth.$selectedYear".obs;

        return Container(
          height: 250,
          width: ARMOYU.screenWidth,
          color: Get.theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    onChanged(selectedDate.value);
                    Get.back();
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
                    child: Obx(
                      () => CupertinoPicker(
                        itemExtent: 32,
                        children: List.generate(
                          yearList.length,
                          (index) {
                            Map<int, String> yearMap = yearList[index];
                            return Text(yearMap.values.last.toString());
                          },
                        ),
                        onSelectedItemChanged: (value) {
                          selectedYear.value = yearList[value].values.first;

                          selectedDate.value =
                              "$selectedDay.$selectedMonth.$selectedYear";

                          updatemonthdonwallowpastdate();

                          onChanged(selectedDate.value);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ARMOYU.screenWidth / 3,
                    height: 150,
                    child: Obx(
                      () => CupertinoPicker(
                        itemExtent: 32,
                        children:
                            List.generate(monthEditiableList.length, (index) {
                          Map<int, String> monthMap = monthEditiableList[index];
                          return Text(monthMap.values.last.toString());
                        }),
                        onSelectedItemChanged: (value) {
                          Map<int, String> monthMap = monthEditiableList[value];
                          selectedMonth.value = monthMap.keys.first.toString();

                          editibledayList.value = List.generate(
                            findDaysInMonth(int.parse(selectedYear.value),
                                int.parse(selectedMonth.value)),
                            (index) => {index + 1: (index + 1).toString()},
                          );

                          selectedDate.value =
                              "$selectedDay.$selectedMonth.$selectedYear";

                          removeDaysAfter();
                          onChanged(selectedDate.value);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ARMOYU.screenWidth / 3,
                    height: 150,
                    child: Obx(
                      () => CupertinoPicker(
                        itemExtent: 32,
                        children: List.generate(
                          editibledayList.length,
                          (index) {
                            Map<int, String> dayMap = editibledayList[index];
                            return Text(dayMap.values.last.toString());
                          },
                        ),
                        onSelectedItemChanged: (value) {
                          Map<int, String> dayMap = editibledayList[value];
                          selectedDay.value = dayMap.keys.first.toString();

                          selectedDate.value =
                              "$selectedDay.$selectedMonth.$selectedYear";
                          onChanged(selectedDate.value);
                        },
                      ),
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

  static int findDaysInMonth(int year, int month) {
    // Ay 1'den 12'ye kadar bir sayı olmalıdır.
    if (month < 1 || month > 12) {
      throw ArgumentError(
          'Geçersiz ay: $month. Ay 1 ila 12 arasında olmalıdır.');
    }

    DateTime endOfMonth =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    log(endOfMonth.day.toString());
    return endOfMonth.day;
  }

  //CupertioTimeSelector
  static Future cupertinoTimepicker({
    required Function(String) onChanged,
  }) {
    var hour = "00".obs;
    var minute = "00".obs;
    var selectedTime = "${hour.value}:${minute.value}".obs;
    return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        var hourList =
            List.generate(24, (index) => {index: (index).toString()}).obs;

        var minuteList =
            List.generate(60, (index) => {index: (index).toString()}).obs;

        if (hour.value.length == 1) {
          hour.value = "0$hour";
        }
        if (minute.value.length == 1) {
          minute.value = "0$minute";
        }

        return Container(
          height: 250,
          width: ARMOYU.screenWidth,
          color: Get.theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    onChanged(selectedTime.value);
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Bitti",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width / 2,
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
                        hour.value = hourList[value].values.first;
                        selectedTime.value = "${hour.value}:${minute.value}";
                        onChanged(selectedTime.value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 2,
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
                        minute.value = minuteList[value].values.first;
                        selectedTime.value = "${hour.value}:${minute.value}";
                        onChanged(selectedTime.value);
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

  static Future cupertinoselector({
    required BuildContext context,
    required title,
    required Function(int index, String value) onChanged,
    required Rx<Selection> selectionList,
    bool looping = false,
  }) {
    if (selectionList.value.list == null) {
      selectionList.value.list!.insert(
        0,
        Select(selectID: 0, title: title, value: title),
      );
    } else if (selectionList.value.list![0].title.toString() != title) {
      selectionList.value.list!.insert(
        0,
        Select(selectID: 0, title: title, value: title),
      );
    }

    var selectedItemID = 0.obs;
    var selectedItem = selectionList.value.list![0].title.obs;

    return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          width: ARMOYU.screenWidth,
          color: Get.theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    onChanged(selectedItemID.value - 1, selectedItem.value);

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
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: ARMOYU.screenWidth,
                    height: 200,
                    child: CupertinoPicker(
                      looping: looping,
                      itemExtent: 32,
                      children: List.generate(selectionList.value.list!.length,
                          (index) {
                        return Text(
                          selectionList.value.list![index].title.toString(),
                          style: index == 0
                              ? const TextStyle(color: Colors.grey)
                              : null,
                        );
                      }),
                      onSelectedItemChanged: (value) {
                        //
                        selectedItemID.value = value;
                        selectedItem.value =
                            selectionList.value.list![value].title.toString();
                        //
                        onChanged(selectedItemID.value - 1, selectedItem.value);
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
