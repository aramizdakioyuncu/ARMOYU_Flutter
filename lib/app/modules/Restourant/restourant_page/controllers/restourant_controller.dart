import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/station.dart';
import 'package:get/get.dart';

class RestourantController extends GetxController {
  final User currentUser;
  RestourantController({
    required this.currentUser,
  });
  var cafe = Rx<Station?>(null);
  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> arguments = Get.arguments;

    cafe.value ??= arguments["cafe"];

    if (cafe.value!.products.isEmpty) {
      fetchequipmentlist();
    }
  }

  var fetchEquipmentProcess = false.obs;
  Future<void> fetchequipmentlist() async {
    if (fetchEquipmentProcess.value) {
      return;
    }
    fetchEquipmentProcess.value = true;

    FunctionsStation f = FunctionsStation(currentUser: currentUser);
    Map<String, dynamic> response =
        await f.fetchEquipments(cafe.value!.stationID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      fetchEquipmentProcess.value = false;
      return;
    }

    cafe.value!.products = [];
    for (var element in response["icerik"]) {
      cafe.value!.products.add(
        StationEquipment(
          productsID: element["equipment_ID"],
          name: element["equipment_name"],
          logo: Media(
            mediaID: element["equipment_ID"],
            mediaURL: MediaURL(
              bigURL: element["equipment_image"],
              normalURL: element["equipment_image"],
              minURL: element["equipment_image"],
            ),
          ),
          banner: Media(
            mediaID: element["equipment_ID"],
            mediaURL: MediaURL(
              bigURL: element["equipment_image"],
              normalURL: element["equipment_image"],
              minURL: element["equipment_image"],
            ),
          ),
          price: element["equipment_price"],
        ),
      );
    }
    fetchEquipmentProcess.value = false;
  }
}
