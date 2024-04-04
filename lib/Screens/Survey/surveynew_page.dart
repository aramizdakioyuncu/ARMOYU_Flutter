import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SurveyNewPage extends StatefulWidget {
  const SurveyNewPage({super.key});

  @override
  State<SurveyNewPage> createState() => _ChatPageState();
}

List<XFile> imagePath = [];
List<Media> media = [];

class _ChatPageState extends State<SurveyNewPage>
    with AutomaticKeepAliveClientMixin<SurveyNewPage> {
  final ScrollController chatScrollController = ScrollController();
  int answercounter = 3;
  List<Map<int, Widget>> answerlist = [
    {
      1: CustomTextfields.costum3("1.Seçenek",
          controller: TextEditingController()),
    },
    {
      2: CustomTextfields.costum3("2.Seçenek",
          controller: TextEditingController()),
    }
  ];

  @override
  bool get wantKeepAlive => true;

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  IconData anwserIcon = Icons.radio_button_checked;

  void addtextfield() {
    final int countID = answercounter;
    answerlist.add({
      countID: CustomTextfields.costum3(
        "Seçenek",
        controller: TextEditingController(),
        suffixiconbutton: IconButton(
          onPressed: () {
            log(answercounter.toString());
            answerlist.removeWhere((element) => element.keys.first == countID);
            setstatefunction();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    });
    answercounter++;
    setstatefunction();
  }

  String? surveyDate;
  String? surveyTime;

  String selectedValue = 'Çoktan Seçmeli'; // Başlangıçta seçili değer
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: AppBar(
        title: const Text("Anket Oluştur"),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Media.mediaList(media, setstatefunction),
              const Text("Anket Sorusu"),
              CustomTextfields.costum3(
                "",
                controller: TextEditingController(),
                maxLines: null,
                minLines: 2,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtons.costum2(
                        text:
                            surveyTime != null ? '$surveyTime' : 'Saat Seçiniz',
                        icon: const Icon(Icons.timelapse_sharp),
                        onPressed: () {
                          WidgetUtility.cupertinoTimepicker(
                            context: context,
                            setstatefunction: setstatefunction,
                            onChanged: (value) {
                              surveyTime = value;
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtons.costum2(
                        icon: const Icon(Icons.date_range),
                        text:
                            surveyDate != null ? '$surveyDate' : 'Tarih seçin',
                        onPressed: () {
                          WidgetUtility.cupertinoDatePicker(
                            context: context,
                            setstatefunction: setstatefunction,
                            onChanged: (value) {
                              surveyDate = value;
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: ARMOYU.buttonColor,
                        child: DropdownButton(
                          underline: const SizedBox(),
                          value: selectedValue,
                          items: <String>[
                            'Çoktan Seçmeli',
                            'Onay Kutuları',
                            'Kısa Yanıt',
                          ].map<DropdownMenuItem<String>>((String value) {
                            IconData? icon;
                            if (value == "Çoktan Seçmeli") {
                              icon = Icons.radio_button_checked_rounded;
                            } else if (value == "Onay Kutuları") {
                              icon = Icons.check_box;
                            } else if (value == "Kısa Yanıt") {
                              icon = Icons.short_text;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(icon),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue =
                                  newValue!; // Seçilen değeri güncelle
                              if (newValue == "Çoktan Seçmeli") {
                                anwserIcon = Icons.radio_button_off_rounded;
                              } else if (newValue == "Onay Kutuları") {
                                anwserIcon =
                                    Icons.check_box_outline_blank_rounded;
                              } else if (newValue == "Kısa Yanıt") {
                                anwserIcon = Icons.short_text;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text("Anket Cevapları"),
              Column(
                children: List.generate(
                  answerlist.length,
                  (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(anwserIcon),
                        ),
                        SizedBox(
                          width: ARMOYU.screenWidth - 60,
                          child: answerlist[index].values.last,
                        ),
                      ],
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  addtextfield();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(anwserIcon, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 80,
                      width: ARMOYU.screenWidth - 60,
                      child: CustomTextfields.costum3("Seçenek Ekle",
                          controller: TextEditingController(), enabled: false),
                    ),
                  ],
                ),
              ),
              CustomButtons.costum1(
                "Oluştur",
                onPressed: () {},
                loadingStatus: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
