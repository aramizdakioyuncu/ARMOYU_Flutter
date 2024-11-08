import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/survey.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Survey/new_survey_page/controllers/surveynew_controller.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyNewPage extends StatelessWidget {
  final UserAccounts currentUserAccounts;
  const SurveyNewPage({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SurveynewController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anket Oluştur"),
        // backgroundColor: ARMOYU.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Obx(
                () => Media.mediaList(
                  controller.media,
                  currentUser: currentUserAccounts.user.value,
                ),
              ),
              const Text("Anket Sorusu"),
              CustomTextfields.costum3(
                controller: controller.controllerSurveyQuestion,
                maxLines: null,
                minLines: 2,
              ),
              SizedBox(
                width: ARMOYU.screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButtons.costum2(
                            text: controller.surveyTime.value != null
                                ? '${controller.surveyTime.value}'
                                : 'Saat Seçiniz',
                            icon: const Icon(Icons.timelapse_sharp),
                            onPressed: () {
                              WidgetUtility.cupertinoTimepicker(
                                context: context,
                                setstatefunction: controller.setstatefunction,
                                onChanged: (value) {
                                  controller.surveyTime.value = value;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButtons.costum2(
                            icon: const Icon(Icons.date_range),
                            text: controller.surveyDate.value != null
                                ? '${controller.surveyDate.value}'
                                : 'Tarih seçin',
                            onPressed: () {
                              WidgetUtility.cupertinoDatePicker(
                                context: context,
                                setstatefunction: controller.setstatefunction,
                                dontallowPastDate: true,
                                yearCount: 1,
                                onChanged: (value) {
                                  controller.surveyDate.value = value;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ARMOYU.buttonColor,
                            ),
                            child: DropdownButton(
                              underline: const SizedBox(),
                              value: controller.selectedValue.value,
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
                                controller.selectedValue.value =
                                    newValue!; // Seçilen değeri güncelle
                                if (newValue == "Çoktan Seçmeli") {
                                  controller.anwserIcon.value =
                                      Icons.radio_button_off_rounded;
                                } else if (newValue == "Onay Kutuları") {
                                  controller.anwserIcon.value =
                                      Icons.check_box_outline_blank_rounded;
                                } else if (newValue == "Kısa Yanıt") {
                                  controller.anwserIcon.value =
                                      Icons.short_text;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text("Anket Cevapları"),
              Obx(
                () => Column(
                  children: List.generate(
                    controller.answerlist.length,
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
                                child: Icon(controller.anwserIcon.value),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: ARMOYU.screenWidth - 60,
                            child: controller.answerlist[index].values.last,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.addtextfield();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        controller.anwserIcon.value,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 115,
                      width: ARMOYU.screenWidth - 60,
                      child: CustomTextfields.costum3(
                          title: "Seçenek Ekle",
                          controller: TextEditingController().obs,
                          enabled: false),
                    ),
                  ],
                ),
              ),
              Obx(
                () => CustomButtons.costum1(
                  text: "Oluştur",
                  onPressed: () async {
                    FunctionsSurvey f = FunctionsSurvey(
                      currentUser: currentUserAccounts.user.value,
                    );

                    if (controller.surveyDate.value == null) {
                      return;
                    }
                    List<String> words =
                        controller.surveyDate.value!.split(".");
                    if (words.isEmpty) {
                      return;
                    }
                    String newDate = "${words[2]}-${words[1]}-${words[0]}";

                    List<String> values = [];
                    for (TextEditingController element
                        in controller.controllers) {
                      values.add(element.text);
                    }
                    Map<String, dynamic> response = await f.createSurvey(
                      controller.controllerSurveyQuestion.value.text,
                      values,
                      "$newDate ${controller.surveyTime}",
                    );

                    if (response["durum"] == 0) {
                      log(response["aciklama"]);
                      return;
                    }
                  },
                  loadingStatus: false.obs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
