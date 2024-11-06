import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveynewController extends GetxController {
  var media = <Media>[].obs;
  var t1 = TextEditingController().obs;
  var t2 = TextEditingController().obs;
  var answercounter = 3.obs;
  var answerlist = <Map<int, Widget>>[].obs;
  var controllers = <TextEditingController>[].obs;

  @override
  void onInit() {
    super.onInit();
    answerlist.value = [
      {
        1: CustomTextfields.costum3(title: "1.Seçenek", controller: t1),
      },
      {
        2: CustomTextfields.costum3(title: "2.Seçenek", controller: t2),
      }
    ];
    controllers.value = [
      t1.value,
      t2.value,
    ];
  }

  void setstatefunction() {}

  var anwserIcon = Icons.radio_button_checked.obs;

  void addtextfield() {
    final int countID = answercounter.value;

    var t = TextEditingController().obs;
    answerlist.add({
      countID: CustomTextfields.costum3(
        title: "Seçenek",
        controller: t,
        suffixiconbutton: IconButton(
          onPressed: () {
            log(answercounter.value.toString());
            answerlist.removeWhere((element) => element.keys.first == countID);
            // setstatefunction();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    });

    controllers.add(t.value);
    answercounter.value++;
    setstatefunction();
  }

  var surveyDate = Rx<String?>(null);
  var surveyTime = Rx<String?>(null);
  var controllerSurveyQuestion = TextEditingController().obs;
  var controllerOptions = TextEditingController().obs;
  var selectedValue = 'Çoktan Seçmeli'.obs; // Başlangıçta seçili değer
}
