import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/blocking.dart';

class ClientFunctionsProfile {
  static Future<String> userblock(int userID) async {
    FunctionsBlocking f = FunctionsBlocking();
    Map<String, dynamic> response = await f.add(userID);
    log(response["aciklama"]);
    return response["aciklama"];
  }
}
