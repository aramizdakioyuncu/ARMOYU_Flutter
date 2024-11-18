import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/station_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:get/get.dart';

class RestourantController extends GetxController {
  var cafe = Rx<Station?>(null);

  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
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

    StationAPI f = StationAPI(currentUser: currentUser.value!);
    Map<String, dynamic> response =
        await f.fetchEquipments(stationID: cafe.value!.stationID);
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
              bigURL: Rx<String>(element["equipment_image"]),
              normalURL: Rx<String>(element["equipment_image"]),
              minURL: Rx<String>(element["equipment_image"]),
            ),
          ),
          banner: Media(
            mediaID: element["equipment_ID"],
            mediaURL: MediaURL(
              bigURL: Rx<String>(element["equipment_image"]),
              normalURL: Rx<String>(element["equipment_image"]),
              minURL: Rx<String>(element["equipment_image"]),
            ),
          ),
          price: element["equipment_price"],
        ),
      );
    }
    fetchEquipmentProcess.value = false;
  }
}
