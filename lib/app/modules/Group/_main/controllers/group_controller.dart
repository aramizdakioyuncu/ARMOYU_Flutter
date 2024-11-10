import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/group.dart';
import 'package:ARMOYU/app/functions/API_Functions/search.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class GroupController extends GetxController {
  late var user = Rxn<User>();
  late var group = Rxn<Group?>(null);

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    user.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;

    group.value = arguments['group'] as Group;

    searchuser.value.addListener(onSearchTextChanged);

    startingfunction();
  }

  var pageviewController = PageController(initialPage: 0).obs;
  var groupProcces = false.obs;
  var groupusersfetchProcces = false.obs;
  // var group = Group(groupUsers: []).obs;

  var ismyGroup = false.obs;

  var groupname = TextEditingController().obs;
  var groupshortname = TextEditingController().obs;
  var groupdescription = TextEditingController().obs;

  var socialdiscord = TextEditingController().obs;
  var socialweb = TextEditingController().obs;

  var searchuser = TextEditingController().obs;

  var searchUserList = <User>[].obs; // RxList<User>
  var selectedUsers = <User>[].obs; // RxList<User>
  Rx<Timer?> searchTimer = Rx<Timer?>(null); // Rx<Timer?>

  var groupdetailSaveproccess = false.obs;
  var changegrouplogoStatus = false.obs;
  var changegroupbannerStatus = false.obs;
  var inviteuserStatus = false.obs;
  var selectedmenuItem = 0.obs;

  var selectedColor = Colors.yellow.obs;
  var nonselectedColor = Colors.white.obs;

  Future<void> startingfunction() async {
    if (group.value!.groupName == null) {
      group.value!.groupUsers = <User>[].obs;
      await fetchGroupInfo();
    } else {
      group.value = group.value;
      group.value!.groupName = group.value!.groupName!;
      groupshortname.value.text = group.value!.groupshortName!;
      socialweb.value.text = group.value!.groupSocial!.web.toString();
      socialdiscord.value.text = group.value!.groupSocial!.discord.toString();
      groupdescription.value.text = group.value!.description == null
          ? ""
          : group.value!.description.toString();
      if (group.value!.groupUsers == null) {
        fetchusersfunction();
      }
    }

    if (user.value!.myGroups == null) {
      ismyGroup.value = false;
      return;
    }

    if (user.value!.myGroups!
        .any((mygroup) => mygroup.groupID == group.value!.groupID)) {
      ismyGroup.value = true;
    }
  }

  Future<void> inviteuserfunction() async {
    if (inviteuserStatus.value) {
      return;
    }

    inviteuserStatus.value = true;
    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    Map<String, dynamic> response = await f.userInvite(
        groupID: group.value!.groupID!, userList: selectedUsers);

    ARMOYUWidget.toastNotification(response["aciklama"].toString());

    if (response["durum"] == 0) {
      inviteuserStatus.value = false;
      return;
    }

    for (var element in response["icerik"]) {
      log("${element["aciklama"]} -- ${element["aciklamadetay"]}");
    }
    selectedUsers.clear();

    inviteuserStatus.value = false;
  }

  void onSearchTextChanged() {
    searchfunction(searchuser.value, searchuser.value.text);
  }

  Future<void> fetchGroupInfo() async {
    if (groupProcces.value) {
      return;
    }
    groupProcces.value = true;
    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    Map<String, dynamic> response = await f.groupFetch(group.value!.groupID!);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      groupProcces.value = false;
      return;
    }

    group.value = Group(
      groupID: response["icerik"]["group_ID"],
      groupName: response["icerik"]["group_name"],
      groupshortName: response["icerik"]["group_shortname"],
      groupURL: response["icerik"]["group_URL"],
      groupType: "",
      joinStatus: response["icerik"]['group_joinstatus'] == 1 ? true : false,
      description: response["icerik"]["group_description"],
      groupSocial: GroupSocial(
        discord: response["icerik"]['group_social']['group_discord'].toString(),
        web: response["icerik"]['group_social']['group_website'] ?? "",
      ),
      groupBanner: Media(
        mediaID: response["icerik"]["group_banner"]["media_ID"],
        mediaURL: MediaURL(
          bigURL:
              Rx<String>(response["icerik"]["group_banner"]["media_bigURL"]),
          normalURL:
              Rx<String>(response["icerik"]["group_banner"]["media_URL"]),
          minURL:
              Rx<String>(response["icerik"]["group_banner"]["media_minURL"]),
        ),
      ),
      groupLogo: Media(
        mediaID: response["icerik"]["group_logo"]["media_ID"],
        mediaURL: MediaURL(
          bigURL: Rx<String>(response["icerik"]["group_logo"]["media_bigURL"]),
          normalURL: Rx<String>(response["icerik"]["group_logo"]["media_URL"]),
          minURL: Rx<String>(response["icerik"]["group_logo"]["media_minURL"]),
        ),
      ),
    );

    groupname.value.text = group.value!.groupName!;
    groupshortname.value.text = group.value!.groupshortName!;

    socialweb.value.text = group.value!.groupSocial!.web.toString();
    socialdiscord.value.text = group.value!.groupSocial!.discord.toString();
    groupdescription.value.text = group.value!.description == null
        ? ""
        : group.value!.description.toString();

    fetchusersfunction();
  }

  void selectmenuItem(int selectedItem) {
    pageviewController.value.jumpToPage(selectedItem);
    selectedmenuItem.value = selectedItem;
  }

  Future<void> fetchusersfunction() async {
    if (groupusersfetchProcces.value) {
      return;
    }
    groupusersfetchProcces.value = true;

    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    Map<String, dynamic> response =
        await f.groupusersFetch(group.value!.groupID!);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      groupProcces.value = false;
      return;
    }

    group.value!.groupUsers = <User>[].obs;

    for (var users in response["icerik"]) {
      group.value!.groupUsers!.add(
        User(
          userID: users["player_ID"],
          displayName: users["player_displayname"],
          userName: users["player_userlogin"],
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(users["player_avatar"]["media_bigURL"]),
              normalURL: Rx<String>(users["player_avatar"]["media_URL"]),
              minURL: Rx<String>(users["player_avatar"]["media_minURL"]),
            ),
          ),
          role: Role(
            roleID: 0,
            name: users["player_role"],
            color: "",
          ),
        ),
      );
    }
    groupusersfetchProcces.value = false;
    group.refresh();
  }

  Future<void> removeuserfromgroup(index) async {
    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    Map<String, dynamic> response = await f.userRemove(
      groupID: group.value!.groupID!,
      userID: group.value!.groupUsers![index].userID!,
    );

    ARMOYUWidget.toastNotification(response["aciklama"].toString());

    if (response["durum"] == 0) {
      return;
    }

    group.value!.groupUsers!.removeWhere(
        (element) => element.userID == group.value!.groupUsers![index].userID);
  }

  Future<void> groupdetailSave() async {
    if (groupdetailSaveproccess.value) {
      return;
    }
    groupdetailSaveproccess.value = true;

    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    Map<String, dynamic> response = await f.groupsettingsSave(
      grupID: group.value!.groupID!,
      groupName: groupname.value.text,
      groupshortName: groupshortname.value.text,
      description: groupdescription.value.text,
      discordInvite: socialdiscord.value.text,
      webLINK: socialweb.value.text,
      joinStatus: group.value!.joinStatus!,
    );

    ARMOYUWidget.toastNotification(response["aciklama"].toString());
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      groupdetailSaveproccess.value = false;

      return;
    }
    groupdetailSaveproccess.value = false;

    int groupIndex = user.value!.myGroups!
        .indexWhere((element) => element.groupID == group.value!.groupID);

    user.value!.myGroups![groupIndex].groupName = groupname.value.text;
    group.value!.groupName = groupname.value.text;
    group.value!.groupName = groupname.value.text;

    user.value!.myGroups![groupIndex].groupshortName =
        groupshortname.value.text;
    group.value!.groupshortName = groupshortname.value.text;
    group.value!.groupshortName = groupshortname.value.text;

    user.value!.myGroups![groupIndex].description = groupdescription.value.text;
    group.value!.description = groupdescription.value.text;

    user.value!.myGroups![groupIndex].groupSocial!.discord =
        socialdiscord.value.text;
    group.value!.groupSocial!.discord = socialdiscord.value.text;

    user.value!.myGroups![groupIndex].groupSocial!.web = socialweb.value.text;
    group.value!.groupSocial!.web = socialweb.value.text;

    user.value!.myGroups![groupIndex].joinStatus = group.value!.joinStatus;
    group.value!.joinStatus = group.value!.joinStatus;
    group.value!.joinStatus = group.value!.joinStatus;
  }

  Future<void> changegrouplogo() async {
    if (changegrouplogoStatus.value) {
      return;
    }

    changegrouplogoStatus.value = true;

    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.square,
    );
    if (selectedImage == null) {
      changegrouplogoStatus.value = false;
      return;
    }
    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);

    log(group.value!.groupID.toString());
    Map<String, dynamic> response = await f.changegroupmedia(imagePath,
        groupID: group.value!.groupID!, category: "logo");

    ARMOYUWidget.toastNotification(response["aciklama"]);

    if (response["durum"] == 0) {
      changegrouplogoStatus.value = false;

      return;
    }

    int groupIndex = user.value!.myGroups!
        .indexWhere((element) => element.groupID == group.value!.groupID);

    user.value!.myGroups![groupIndex].groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response["aciklamadetay"].toString()),
        normalURL: Rx<String>(response["aciklamadetay"].toString()),
        minURL: Rx<String>(response["aciklamadetay"].toString()),
      ),
    );

    group.value!.groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response["aciklamadetay"].toString()),
        normalURL: Rx<String>(response["aciklamadetay"].toString()),
        minURL: Rx<String>(response["aciklamadetay"].toString()),
      ),
    );

    group.value!.groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response["aciklamadetay"].toString()),
        normalURL: Rx<String>(response["aciklamadetay"].toString()),
        minURL: Rx<String>(response["aciklamadetay"].toString()),
      ),
    );

    changegrouplogoStatus.value = false;
  }

  Future<void> changegroupbanner() async {
    if (changegroupbannerStatus.value) {
      return;
    }

    changegroupbannerStatus.value = true;

    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.ratio16x9,
    );
    if (selectedImage == null) {
      changegroupbannerStatus.value = false;

      return;
    }
    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);

    Map<String, dynamic> response = await f.changegroupmedia(imagePath,
        groupID: group.value!.groupID!, category: "banner");

    ARMOYUWidget.toastNotification(response["aciklama"]);

    if (response["durum"] == 0) {
      changegroupbannerStatus.value = false;

      return;
    }

    int groupIndex = user.value!.myGroups!
        .indexWhere((element) => element.groupID == group.value!.groupID);

    user.value!.myGroups![groupIndex].groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response["aciklamadetay"].toString()),
        normalURL: Rx<String>(response["aciklamadetay"].toString()),
        minURL: Rx<String>(response["aciklamadetay"].toString()),
      ),
    );

    group.value!.groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response["aciklamadetay"].toString()),
        normalURL: Rx<String>(response["aciklamadetay"].toString()),
        minURL: Rx<String>(response["aciklamadetay"].toString()),
      ),
    );

    group.value!.groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response["aciklamadetay"].toString()),
        normalURL: Rx<String>(response["aciklamadetay"].toString()),
        minURL: Rx<String>(response["aciklamadetay"].toString()),
      ),
    );

    changegroupbannerStatus.value = false;
  }

  Future<void> loadSkeletonpost() async {
    searchUserList.clear();
    // _searchuserList.add(const SkeletonSearch());
  }

  Future<void> searchfunction(
    TextEditingController controller,
    String text,
  ) async {
    if (controller.text == "" || controller.text.isEmpty) {
      searchTimer.value!.cancel();

      searchUserList.clear();
      return;
    }

    searchTimer.value = Timer(const Duration(milliseconds: 500), () async {
      loadSkeletonpost();

      log("$text ${controller.text}");

      if (text != controller.text) {
        return;
      }
      FunctionsSearchEngine f = FunctionsSearchEngine(
        currentUser: user.value!,
      );
      Map<String, dynamic> response = await f.onlyusers(text, 1);
      if (response["durum"] == 0) {
        log(response["aciklama"]);
        return;
      }

      try {
        searchUserList.clear();
      } catch (e) {
        log(e.toString());
      }

      int dynamicItemCount = response["icerik"].length;
      //Eğer cevap gelene kadar yeni bir şeyler yazmışsa
      if (text != controller.text) {
        return;
      }
      for (int i = 0; i < dynamicItemCount; i++) {
        searchUserList.add(
          User(
            userID: response["icerik"][i]["ID"],
            displayName: response["icerik"][i]["Value"],
            userName: response["icerik"][i]["username"],
            avatar: Media(
              mediaID: 11,
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["avatar"],
                normalURL: response["icerik"][i]["avatar"],
                minURL: response["icerik"][i]["avatar"],
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> leavegroup() async {
    FunctionsGroup f = FunctionsGroup(
      currentUser: user.value!,
    );
    Map<String, dynamic> response = await f.groupleave(group.value!.groupID!);
    if (response["durum"] == 0) {
      ARMOYUWidget.toastNotification(response["aciklama"].toString());
      return;
    }

    user.value!.myGroups!
        .removeWhere((element) => element.groupID == group.value!.groupID);

    // Navigator.pop(context);
    Get.back();
  }
}
