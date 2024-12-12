import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:image_picker/image_picker.dart';

class GroupAPI {
  final User currentUser;
  GroupAPI({required this.currentUser});

  Future<GroupDetailResponse> groupFetch({required int grupID}) async {
    return await API.service.groupServices.groupFetch(grupID: grupID);
  }

  Future<GroupUsersResponse> groupusersFetch({required int grupID}) async {
    return await API.service.groupServices.groupusersFetch(grupID: grupID);
  }

  Future<GroupLeaveResponse> leave({required int grupID}) async {
    return await API.service.groupServices.groupLeave(grupID: grupID);
  }

  Future<GroupSettingsResponse> groupsettingsSave({
    required int grupID,
    required String groupName,
    required String groupshortName,
    required String description,
    required String discordInvite,
    required String webLINK,
    required bool joinStatus,
  }) async {
    return await API.service.groupServices.groupsettingsSave(
      grupID: grupID,
      groupName: groupName,
      groupshortName: groupshortName,
      description: description,
      discordInvite: discordInvite,
      webLINK: webLINK,
      joinStatus: joinStatus,
    );
  }

  Future<GroupChangeMediaResponse> changegroupmedia({
    required List<XFile> files,
    required int groupID,
    required String category,
  }) async {
    return await API.service.groupServices.changegroupmedia(
      files: files,
      groupID: groupID,
      category: category,
    );
  }

  Future<GroupRequestAnswerResponse> grouprequestanswer({
    required int groupID,
    required String answer,
  }) async {
    return await API.service.groupServices.grouprequestanswer(
      groupID: groupID,
      answer: answer,
    );
  }

  Future<GroupUserInviteResponse> userInvite({
    required int groupID,
    required List<String> userList, //Username
  }) async {
    return await API.service.groupServices.groupuserInvite(
      groupID: groupID,
      userList: userList,
    );
  }

  Future<GroupUserKickResponse> userRemove({
    required int groupID,
    required int userID,
  }) async {
    return await API.service.groupServices.groupuserRemove(
      groupID: groupID,
      userID: userID,
    );
  }

  Future<GroupCreateResponse> groupcreate({
    required String grupadi,
    required String kisaltmaadi,
    required int grupkategori,
    required int grupkategoridetay,
    required int varsayilanoyun,
  }) async {
    return await API.service.groupServices.groupcreate(
      grupadi: grupadi,
      kisaltmaadi: kisaltmaadi,
      grupkategori: grupkategori,
      grupkategoridetay: grupkategoridetay,
      varsayilanoyun: varsayilanoyun,
    );
  }
}
