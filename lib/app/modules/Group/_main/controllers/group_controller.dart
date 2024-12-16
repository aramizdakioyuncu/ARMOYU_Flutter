import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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

    GroupUserInviteResponse response = await API.service.groupServices
        .groupuserInvite(
            groupID: group.value!.groupID!,
            userList:
                selectedUsers.map((user) => user.userName!.value).toList());

    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
      inviteuserStatus.value = false;
      return;
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

    GroupDetailResponse response = await API.service.groupServices
        .groupFetch(grupID: group.value!.groupID!);
    if (!response.result.status) {
      log(response.result.description.toString());
      groupProcces.value = false;
      return;
    }

    group.value = Group(
      groupID: response.response!.groupID,
      groupName: response.response!.groupName,
      groupshortName: response.response!.groupShortname,
      groupURL: response.response!.groupURL,
      groupType: "",
      joinStatus: response.response!.groupJoinStatus ? true.obs : false.obs,
      description: response.response!.groupDescription,
      groupSocial: GroupSocial(
        discord: response.response!.groupSocial.discord,
        web: response.response!.groupSocial.website ?? "",
      ),
      groupBanner: Media(
        mediaID: response.response!.groupID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.response!.groupBanner.bigURL),
          normalURL: Rx<String>(response.response!.groupBanner.normalURL),
          minURL: Rx<String>(response.response!.groupBanner.minURL),
        ),
      ),
      groupLogo: Media(
        mediaID: response.response!.groupID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.response!.groupLogo.bigURL),
          normalURL: Rx<String>(response.response!.groupLogo.normalURL),
          minURL: Rx<String>(response.response!.groupLogo.minURL),
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

    GroupUsersResponse response = await API.service.groupServices
        .groupusersFetch(grupID: group.value!.groupID!);
    if (!response.result.status) {
      log(response.result.description.toString());
      groupProcces.value = false;
      return;
    }

    group.value!.groupUsers = <User>[].obs;

    for (var users in response.response!.user) {
      group.value!.groupUsers!.add(
        User(
          userID: users.userID,
          displayName: Rx<String>(users.displayname),
          userName: Rx<String>(users.username!),
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(users.avatar.bigURL),
              normalURL: Rx<String>(users.avatar.bigURL),
              minURL: Rx<String>(users.avatar.minURL),
            ),
          ),
          role: Role(
            roleID: 0,
            name: users.role!,
            color: "",
          ),
        ),
      );
    }
    groupusersfetchProcces.value = false;
    group.refresh();
  }

  Future<void> removeuserfromgroup(index) async {
    GroupUserKickResponse response =
        await API.service.groupServices.groupuserRemove(
      groupID: group.value!.groupID!,
      userID: group.value!.groupUsers![index].userID!,
    );

    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
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

    GroupSettingsResponse response =
        await API.service.groupServices.groupsettingsSave(
      grupID: group.value!.groupID!,
      groupName: groupname.value.text,
      groupshortName: groupshortname.value.text,
      description: groupdescription.value.text,
      discordInvite: socialdiscord.value.text,
      webLINK: socialweb.value.text,
      joinStatus: group.value!.joinStatus!.value,
    );

    ARMOYUWidget.toastNotification(response.result.description.toString());
    if (!response.result.status) {
      log(response.result.description.toString());
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

    List<XFile> imagePath = [];
    imagePath.add(selectedImage);

    log(group.value!.groupID.toString());
    GroupChangeMediaResponse response = await API.service.groupServices
        .changegroupmedia(
            files: imagePath, groupID: group.value!.groupID!, category: "logo");

    ARMOYUWidget.toastNotification(response.result.description);

    if (!response.result.status) {
      changegrouplogoStatus.value = false;

      return;
    }

    int groupIndex = user.value!.myGroups!
        .indexWhere((element) => element.groupID == group.value!.groupID);

    user.value!.myGroups![groupIndex].groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.result.descriptiondetail.toString()),
        normalURL: Rx<String>(response.result.descriptiondetail.toString()),
        minURL: Rx<String>(response.result.descriptiondetail.toString()),
      ),
    );

    group.value!.groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.result.descriptiondetail.toString()),
        normalURL: Rx<String>(response.result.descriptiondetail.toString()),
        minURL: Rx<String>(response.result.descriptiondetail.toString()),
      ),
    );

    group.value!.groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.result.descriptiondetail.toString()),
        normalURL: Rx<String>(response.result.descriptiondetail.toString()),
        minURL: Rx<String>(response.result.descriptiondetail.toString()),
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

    List<XFile> imagePath = [];
    imagePath.add(selectedImage);

    GroupChangeMediaResponse response = await API.service.groupServices
        .changegroupmedia(
            files: imagePath,
            groupID: group.value!.groupID!,
            category: "banner");

    ARMOYUWidget.toastNotification(response.result.description);

    if (!response.result.status) {
      changegroupbannerStatus.value = false;

      return;
    }

    int groupIndex = user.value!.myGroups!
        .indexWhere((element) => element.groupID == group.value!.groupID);

    user.value!.myGroups![groupIndex].groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.result.descriptiondetail.toString()),
        normalURL: Rx<String>(response.result.descriptiondetail.toString()),
        minURL: Rx<String>(response.result.descriptiondetail.toString()),
      ),
    );

    group.value!.groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.result.descriptiondetail.toString()),
        normalURL: Rx<String>(response.result.descriptiondetail.toString()),
        minURL: Rx<String>(response.result.descriptiondetail.toString()),
      ),
    );

    group.value!.groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.result.descriptiondetail.toString()),
        normalURL: Rx<String>(response.result.descriptiondetail.toString()),
        minURL: Rx<String>(response.result.descriptiondetail.toString()),
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
      if (searchTimer.value != null) {
        searchTimer.value!.cancel();
      }

      searchUserList.clear();
      return;
    }

    searchTimer.value = Timer(const Duration(milliseconds: 500), () async {
      loadSkeletonpost();

      log("$text ${controller.text}");

      if (text != controller.text) {
        return;
      }

      SearchListResponse response =
          await API.service.searchServices.onlyusers(searchword: text, page: 1);
      if (!response.result.status) {
        log(response.result.description);
        return;
      }

      try {
        searchUserList.clear();
      } catch (e) {
        log(e.toString());
      }

      //Eğer cevap gelene kadar yeni bir şeyler yazmışsa
      if (text != controller.text) {
        return;
      }

      for (var element in response.response!.search) {
        searchUserList.add(
          User(
            userID: element.id,
            displayName: RxString(element.value),
            userName: RxString(element.username!),
            avatar: Media(
              mediaID: 11,
              mediaURL: MediaURL(
                bigURL: Rx<String>(element.avatar!),
                normalURL: Rx<String>(element.avatar!),
                minURL: Rx<String>(element.avatar!),
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> leavegroup() async {
    GroupLeaveResponse response = await API.service.groupServices
        .groupLeave(grupID: group.value!.groupID!);
    if (!response.result.status) {
      ARMOYUWidget.toastNotification(response.result.description.toString());
      return;
    }

    user.value!.myGroups!
        .removeWhere((element) => element.groupID == group.value!.groupID);

    // Navigator.pop(context);
    Get.back();
  }
}
