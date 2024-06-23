import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/survey.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:flutter/material.dart';

class SurveyNewPage extends StatefulWidget {
  final User currentUser;
  const SurveyNewPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<SurveyNewPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<SurveyNewPage>
    with AutomaticKeepAliveClientMixin<SurveyNewPage> {
  final List<Media> _media = [];
  final TextEditingController _t1 = TextEditingController();
  final TextEditingController _t2 = TextEditingController();
  int _answercounter = 3;
  List<Map<int, Widget>> _answerlist = [];
  List<TextEditingController> _controllers = [];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _answerlist = [
      {
        1: CustomTextfields(setstate: setstatefunction)
            .costum3(title: "1.Seçenek", controller: _t1),
      },
      {
        2: CustomTextfields(setstate: setstatefunction)
            .costum3(title: "2.Seçenek", controller: _t2),
      }
    ];
    _controllers = [
      _t1,
      _t2,
    ];
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  IconData anwserIcon = Icons.radio_button_checked;

  void addtextfield() {
    final int countID = _answercounter;

    final TextEditingController t = TextEditingController();
    _answerlist.add({
      countID: CustomTextfields(setstate: setstatefunction).costum3(
        title: "Seçenek",
        controller: t,
        suffixiconbutton: IconButton(
          onPressed: () {
            log(_answercounter.toString());
            _answerlist.removeWhere((element) => element.keys.first == countID);
            setstatefunction();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    });

    _controllers.add(t);
    _answercounter++;
    setstatefunction();
  }

  String? surveyDate;
  String? surveyTime;
  TextEditingController controllerSurveyQuestion = TextEditingController();
  TextEditingController controllerOptions = TextEditingController();
  String selectedValue = 'Çoktan Seçmeli'; // Başlangıçta seçili değer
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: const Text("Anket Oluştur"),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Media.mediaList(_media, setstatefunction,
                  currentUser: widget.currentUser),
              const Text("Anket Sorusu"),
              CustomTextfields(setstate: setstatefunction).costum3(
                controller: controllerSurveyQuestion,
                maxLines: null,
                minLines: 2,
              ),
              SizedBox(
                width: ARMOYU.screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtons.costum2(
                          text: surveyTime != null
                              ? '$surveyTime'
                              : 'Saat Seçiniz',
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
                          text: surveyDate != null
                              ? '$surveyDate'
                              : 'Tarih seçin',
                          onPressed: () {
                            WidgetUtility.cupertinoDatePicker(
                              context: context,
                              setstatefunction: setstatefunction,
                              dontallowPastDate: true,
                              yearCount: 1,
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ARMOYU.buttonColor,
                          ),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            value: selectedValue,
                            dropdownColor: ARMOYU.buttonColor,
                            borderRadius: BorderRadius.circular(3),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Icon(
                                        icon,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
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
              ),
              const Text("Anket Cevapları"),
              Column(
                children: List.generate(
                  _answerlist.length,
                  (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(anwserIcon),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ARMOYU.screenWidth - 60,
                          child: _answerlist[index].values.last,
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
                      height: 115,
                      width: ARMOYU.screenWidth - 60,
                      child: CustomTextfields(setstate: setstatefunction)
                          .costum3(
                              title: "Seçenek Ekle",
                              controller: TextEditingController(),
                              enabled: false),
                    ),
                  ],
                ),
              ),
              CustomButtons.costum1(
                text: "Oluştur",
                onPressed: () async {
                  FunctionsSurvey f =
                      FunctionsSurvey(currentUser: widget.currentUser);

                  if (surveyDate == null) {
                    return;
                  }
                  List<String> words = surveyDate!.split(".");
                  if (words.isEmpty) {
                    return;
                  }
                  String newDate = "${words[2]}-${words[1]}-${words[0]}";

                  List<String> values = [];
                  for (TextEditingController element in _controllers) {
                    values.add(element.text);
                  }
                  Map<String, dynamic> response = await f.createSurvey(
                    controllerSurveyQuestion.text,
                    values,
                    "$newDate $surveyTime",
                  );

                  if (response["durum"] == 0) {
                    log(response["aciklama"]);
                    return;
                  }
                },
                loadingStatus: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
