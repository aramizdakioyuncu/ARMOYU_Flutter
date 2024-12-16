import 'dart:developer';

import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/player_pop_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class ClientFunctionsSocail {
  Future<List<Map<String, String>>> loadXPCards(
      int page, List<Map<String, String>> list) async {
    FunctionService f = FunctionService();
    PlayerPopResponse response = await f.getplayerxp(1);
    if (!response.result.status) {
      log(response.result.description);
      return list;
    }
    if (page == 1) {
      list.clear();
    }

    for (APIPlayerPop element in response.response!) {
      list.add(
        {
          "userID": element.oyuncuID.toString(),
          "image": element.oyuncuAvatar,
          "displayname": element.oyuncuAdSoyad,
          "score": element.oyuncuSeviyeSezonlukXP,
        },
      );
    }

    return list;
  }

  Future<List<Map<String, String>>> loadpopCards(
      int page, List<Map<String, String>> list) async {
    FunctionService f = FunctionService();
    PlayerPopResponse response = await f.getplayerpop(1);
    if (!response.result.status) {
      log(response.result.description);
      return list;
    }
    if (page == 1) {
      list.clear();
    }

    for (APIPlayerPop element in response.response!) {
      list.add({
        "userID": element.oyuncuID.toString(),
        "image": element.oyuncuAvatar,
        "displayname": element.oyuncuAdSoyad,
        "score": element.oyuncuPop.toString(),
      });
    }
    return list;
  }
}
