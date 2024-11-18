import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:image_picker/image_picker.dart';

class GroupAPI {
  final User currentUser;
  GroupAPI({required this.currentUser});

  Future<Map<String, dynamic>> groupFetch({
    required int grupID,
  }) async {
    return await API.service.groupServices.groupFetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      grupID: grupID,
    );
  }

  Future<Map<String, dynamic>> groupusersFetch({
    required int grupID,
  }) async {
    return await API.service.groupServices.groupusersFetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      grupID: grupID,
    );
  }

  Future<Map<String, dynamic>> leave({
    required int grupID,
  }) async {
    return await API.service.groupServices.groupLeave(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      grupID: grupID,
    );
  }

  Future<Map<String, dynamic>> groupsettingsSave({
    required int grupID,
    required String groupName,
    required String groupshortName,
    required String description,
    required String discordInvite,
    required String webLINK,
    required bool joinStatus,
  }) async {
    return await API.service.groupServices.groupsettingsSave(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      grupID: grupID,
      groupName: groupName,
      groupshortName: groupshortName,
      description: description,
      discordInvite: discordInvite,
      webLINK: webLINK,
      joinStatus: joinStatus,
    );
  }

  Future<Map<String, dynamic>> changegroupmedia({
    required List<XFile> files,
    required int groupID,
    required String category,
  }) async {
    return await API.service.groupServices.changegroupmedia(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      files: files,
      groupID: groupID,
      category: category,
    );
  }

  Future<Map<String, dynamic>> grouprequestanswer({
    required int groupID,
    required String answer,
  }) async {
    return await API.service.groupServices.grouprequestanswer(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      groupID: groupID,
      answer: answer,
    );
  }

  Future<Map<String, dynamic>> userInvite({
    required int groupID,
    required List<String> userList, //Username
  }) async {
    return await API.service.groupServices.groupuserInvite(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      groupID: groupID,
      userList: userList,
    );
  }

  Future<Map<String, dynamic>> userRemove({
    required int groupID,
    required int userID,
  }) async {
    return await API.service.groupServices.groupuserRemove(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      groupID: groupID,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> groupcreate({
    required String grupadi,
    required String kisaltmaadi,
    required int grupkategori,
    required int grupkategoridetay,
    required int varsayilanoyun,
  }) async {
    return await API.service.groupServices.groupcreate(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      grupadi: grupadi,
      kisaltmaadi: kisaltmaadi,
      grupkategori: grupkategori,
      grupkategoridetay: grupkategoridetay,
      varsayilanoyun: varsayilanoyun,
    );
  }
}
