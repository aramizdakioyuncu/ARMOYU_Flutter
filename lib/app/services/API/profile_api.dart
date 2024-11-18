import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAPI {
  final User currentUser;
  ProfileAPI({required this.currentUser});

  Future<Map<String, dynamic>> invitelist({
    required int page,
  }) async {
    return await API.service.profileServices.invitelist(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> sendauthmailURL({
    required int userID,
  }) async {
    return await API.service.profileServices.sendauthmailURL(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> invitecoderefresh() async {
    return await API.service.profileServices.invitecoderefresh(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> friendlist({
    required int userID,
    required int page,
  }) async {
    return await API.service.profileServices.friendlist(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
      page: page,
    );
  }

  Future<Map<String, dynamic>> friendrequest({
    required int userID,
  }) async {
    return await API.service.profileServices.friendrequest(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> friendrequestanswer({
    required int userID,
    required int answer,
  }) async {
    return await API.service.profileServices.friendrequestanswer(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
      answer: answer,
    );
  }

  Future<Map<String, dynamic>> userdurting({
    required int userID,
  }) async {
    return await API.service.profileServices.userdurting(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> friendremove({
    required int userID,
  }) async {
    return await API.service.profileServices.friendremove(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> defaultavatar() async {
    return await API.service.profileServices.defaultavatar(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> changeavatar({
    required List<XFile> files,
  }) async {
    return await API.service.profileServices.changeavatar(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      files: files,
    );
  }

  Future<Map<String, dynamic>> changebanner({
    required List<XFile> files,
  }) async {
    return await API.service.profileServices.changebanner(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      files: files,
    );
  }

  Future<Map<String, dynamic>> selectfavteam({
    int? teamID,
  }) async {
    return await API.service.profileServices.selectfavteam(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      teamID: teamID,
    );
  }

  Future<Map<String, dynamic>> saveprofiledetails({
    required String firstname,
    required String lastname,
    required String aboutme,
    required String email,
    required String countryID,
    required String provinceID,
    required String birthday,
    required String phoneNumber,
    required String passwordControl,
  }) async {
    return await API.service.profileServices.saveprofiledetails(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      firstname: firstname,
      aboutme: aboutme,
      lastname: lastname,
      email: email,
      countryID: countryID,
      provinceID: provinceID,
      birthday: birthday,
      phoneNumber: phoneNumber,
      passwordControl: passwordControl,
    );
  }
}
