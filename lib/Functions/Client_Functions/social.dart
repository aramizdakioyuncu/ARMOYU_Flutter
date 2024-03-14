import 'dart:developer';

import 'package:ARMOYU/Functions/functions_service.dart';

class ClientFunctionsSocail {
  Future<List<Map<String, String>>> loadXPCards(
      int page, List<Map<String, String>> list) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerxp(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return list;
    }
    if (page == 1) {
      list.clear();
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      list.add(
        {
          "userID": response["icerik"][i]["oyuncuID"].toString(),
          "image": response["icerik"][i]["oyuncuavatar"],
          "displayname": response["icerik"][i]["oyuncuadsoyad"],
          "score": response["icerik"][i]["oyuncuseviyesezonlukxp"].toString()
        },
      );
    }

    return list;
  }

  Future<List<Map<String, String>>> loadpopCards(
      int page, List<Map<String, String>> list) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerpop(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return list;
    }
    if (page == 1) {
      list.clear();
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      list.add({
        "userID": response["icerik"][i]["oyuncuID"].toString(),
        "image": response["icerik"][i]["oyuncuavatar"],
        "displayname": response["icerik"][i]["oyuncuadsoyad"],
        "score": response["icerik"][i]["oyuncupop"].toString()
      });
    }
    return list;
  }
}
