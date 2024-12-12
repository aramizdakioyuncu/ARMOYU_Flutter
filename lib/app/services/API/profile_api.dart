import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAPI {
  final User currentUser;
  ProfileAPI({required this.currentUser});

  Future<ProfileInviteListResponse> invitelist({required int page}) async {
    return await API.service.profileServices.invitelist(page: page);
  }

  Future<ServiceResult> sendauthmailURL({required int userID}) async {
    return await API.service.profileServices.sendauthmailURL(userID: userID);
  }

  Future<ServiceResult> invitecoderefresh() async {
    return await API.service.profileServices.invitecoderefresh();
  }

  Future<ProfileFriendListResponse> friendlist({
    required int userID,
    required int page,
  }) async {
    return await API.service.profileServices.friendlist(
      userID: userID,
      page: page,
    );
  }

  Future<ServiceResult> friendrequest({required int userID}) async {
    return await API.service.profileServices.friendrequest(userID: userID);
  }

  Future<ServiceResult> friendrequestanswer({
    required int userID,
    required int answer,
  }) async {
    return await API.service.profileServices.friendrequestanswer(
      userID: userID,
      answer: answer,
    );
  }

  Future<ServiceResult> userdurting({required int userID}) async {
    return await API.service.profileServices.userdurting(userID: userID);
  }

  Future<ServiceResult> friendremove({required int userID}) async {
    return await API.service.profileServices.friendremove(userID: userID);
  }

  Future<ServiceResult> defaultavatar() async {
    return await API.service.profileServices.defaultavatar();
  }

  Future<ServiceResult> changeavatar({required List<XFile> files}) async {
    return await API.service.profileServices.changeavatar(files: files);
  }

  Future<ServiceResult> changebanner({required List<XFile> files}) async {
    return await API.service.profileServices.changebanner(files: files);
  }

  Future<ServiceResult> selectfavteam({int? teamID}) async {
    return await API.service.profileServices.selectfavteam(teamID: teamID);
  }

  Future<ServiceResult> saveprofiledetails({
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
