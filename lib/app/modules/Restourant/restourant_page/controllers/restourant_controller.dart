import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/station/station_equipment_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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

    StationFetchEquipmentListResponse response = await API
        .service.stationServices
        .fetchEquipments(stationID: cafe.value!.stationID);
    if (!response.result.status) {
      log(response.result.description);
      fetchEquipmentProcess.value = false;
      return;
    }

    cafe.value!.products = [];

    for (APIStationEquipmentList element in response.response!) {
      cafe.value!.products.add(
        StationEquipment(
          productsID: element.equipmentId,
          name: element.equipmentName,
          logo: Media(
            mediaID: element.equipmentId,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.equipmentImage.bigURL),
              normalURL: Rx<String>(element.equipmentImage.normalURL),
              minURL: Rx<String>(element.equipmentImage.minURL),
            ),
          ),
          banner: Media(
            mediaID: element.equipmentId,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.equipmentImage.bigURL),
              normalURL: Rx<String>(element.equipmentImage.normalURL),
              minURL: Rx<String>(element.equipmentImage.minURL),
            ),
          ),
          price: element.equipmentPrice,
        ),
      );
    }
    fetchEquipmentProcess.value = false;
  }
}
