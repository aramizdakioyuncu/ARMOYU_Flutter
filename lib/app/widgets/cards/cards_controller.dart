import 'dart:developer';

import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsController extends GetxController {
  final String title;
  final List<Map<String, String>> content;
  final Icon icon;
  final Color effectcolor;
  final bool firstFetch;

  CardsController({
    required this.title,
    required this.content,
    required this.icon,
    required this.effectcolor,
    required this.firstFetch,
  });

  var morefetchProcces = false.obs;
  var firstFetchProcces = false.obs;

  var xtitle = Rxn<String>(null);
  var xcontent = Rxn<List<Map<String, String>>>(null);
  var xicon = Rxn<Icon>(null);
  var xeffectcolor = Rxn<Color>(null);
  var xscrollController = Rxn<ScrollController>(null);
  var xfirstFetch = Rxn<bool>(null);

  @override
  void onInit() {
    super.onInit();

    xtitle.value = title;
    xcontent.value = content;
    xicon.value = icon;
    xeffectcolor.value = effectcolor;
    xscrollController.value = ScrollController();
    xfirstFetch.value = firstFetch;

    if (!firstFetchProcces.value && xfirstFetch.value!) {
      morefetchinfo();
      firstFetchProcces.value = true;
    }
    xscrollController.value!.addListener(() {
      if (xscrollController.value!.position.pixels >=
          xscrollController.value!.position.maxScrollExtent * 0.8) {
        morefetchinfo();
      }
    });
  }

  Future<void> morefetchinfo() async {
    if (morefetchProcces.value) {
      return;
    }
    morefetchProcces.value = true;

    FunctionService f = FunctionService();
    log("${xtitle.value}  ${xtitle.value}  ");

    PlayerPopResponse response;
    if (xtitle.value == "POP") {
      response = await f.getplayerpop(
          int.parse(((xcontent.value!.length ~/ 10) + 1).toString()));
    } else {
      response = await f.getplayerxp(
          int.parse(((xcontent.value!.length ~/ 10) + 1).toString()));
    }

    if (!response.result.status) {
      log(response.result.description);
      morefetchProcces.value = false;
      return;
    }
    xcontent.value ??= <Map<String, String>>[];
    for (APIPlayerPop element in response.response!) {
      xcontent.value!.add({
        "userID": element.oyuncuID.toString(),
        "image": element.oyuncuAvatar,
        "displayname": element.oyuncuAdSoyad,
        "score": xtitle.value == "POP"
            ? element.oyuncuPop.toString()
            : element.oyuncuSeviyeSezonlukXP.toString()
      });
    }

    log(((xcontent.value!.length ~/ 10)).toString());
    morefetchProcces.value = false;
  }
}
