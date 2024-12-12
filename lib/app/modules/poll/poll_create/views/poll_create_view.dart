import 'dart:developer';

import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/modules/poll/poll_create/controllers/poll_create_controller.dart';
import 'package:ARMOYU/app/services/API/survey_api.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollCreateView extends StatelessWidget {
  const PollCreateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PollCreateController());
    return Scaffold(
      appBar: AppBar(
        title: Text(PollKeys.createPoll.tr),
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
                  currentUser: controller.user.value!,
                ),
              ),
              Text(PollKeys.pollquestion.tr),
              CustomTextfields.costum3(
                controller: controller.controllerSurveyQuestion,
                maxLines: null,
                minLines: 2,
              ),
              SizedBox(
                width: Get.width,
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
                                : PollKeys.selectHour.tr,
                            icon: const Icon(Icons.timelapse_sharp),
                            onPressed: () {
                              WidgetUtility.cupertinoTimepicker(
                                onChanged: (value) {
                                  log(value);
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
                                : PollKeys.selectDate.tr,
                            onPressed: () {
                              WidgetUtility.cupertinoDatePicker(
                                context: context,
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
                              // color: ARMOYU.buttonColor,
                            ),
                            child: DropdownButton(
                              underline: const SizedBox(),
                              value: controller.selectedValue.value,
                              // dropdownColor: ARMOYU.buttonColor,
                              borderRadius: BorderRadius.circular(3),
                              items: <String>[
                                PollKeys.selectPollMultipleChoice.tr,
                                PollKeys.selectPollCheckboxes.tr,
                                PollKeys.selectPollShortAnswer.tr
                              ].map<DropdownMenuItem<String>>((String value) {
                                IconData? icon;
                                if (value ==
                                    PollKeys.selectPollMultipleChoice) {
                                  icon = Icons.radio_button_checked_rounded;
                                } else if (value ==
                                    PollKeys.selectPollCheckboxes) {
                                  icon = Icons.check_box;
                                } else if (value ==
                                    PollKeys.selectPollShortAnswer) {
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
                                if (newValue ==
                                    PollKeys.selectPollMultipleChoice.tr) {
                                  controller.anwserIcon.value =
                                      Icons.radio_button_off_rounded;
                                } else if (newValue ==
                                    PollKeys.selectPollCheckboxes.tr) {
                                  controller.anwserIcon.value =
                                      Icons.check_box_outline_blank_rounded;
                                } else if (newValue ==
                                    PollKeys.selectPollShortAnswer.tr) {
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
              Text(PollKeys.pollanswers.tr),
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
              Obx(
                () => GestureDetector(
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
                            title: PollKeys.pollAddOption.tr,
                            controller: TextEditingController().obs,
                            enabled: false),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => CustomButtons.costum1(
                  text: CommonKeys.submit.tr,
                  onPressed: () async {
                    controller.poolproccess.value = true;
                    SurveyAPI f =
                        SurveyAPI(currentUser: controller.user.value!);

                    if (controller.surveyDate.value == null) {
                      controller.poolproccess.value = false;
                      return;
                    }
                    List<String> words =
                        controller.surveyDate.value!.split(".");
                    if (words.isEmpty) {
                      controller.poolproccess.value = false;
                      return;
                    }
                    String newDate = "${words[2]}-${words[1]}-${words[0]}";

                    List<String> values = [];
                    for (TextEditingController element
                        in controller.controllers) {
                      values.add(element.text);
                    }
                    ServiceResult response = await f.createSurvey(
                      surveyQuestion:
                          controller.controllerSurveyQuestion.value.text,
                      options: values,
                      date: "$newDate ${controller.surveyTime}",
                    );

                    if (!response.status) {
                      log(response.description);
                      controller.poolproccess.value = false;
                      return;
                    }
                    controller.poolproccess.value = false;

                    Get.back();
                  },
                  loadingStatus: controller.poolproccess,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
