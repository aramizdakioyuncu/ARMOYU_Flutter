import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class JoinusAPI {
  final User currentUser;
  JoinusAPI({required this.currentUser});
//////////////////////JOINUS////////////////////
  Future<JoinUsFetchDepartmentsResponse> fetchdepartment() async {
    return await API.service.joinusServices.fetchdepartment();
  }

  Future<JoinUsApplicationsResponse> applicationList(
      {required int page}) async {
    return await API.service.joinusServices.applicationList(page: page);
  }

  Future<JoinUsRequestJoinDepartmentResponse> requestjoindepartment({
    required int positionID,
    required String whyjoin,
    required String whyposition,
    required String howmachtime,
  }) async {
    return await API.service.joinusServices.requestjoindepartment(
      positionID: positionID,
      whyjoin: whyjoin,
      whyposition: whyposition,
      howmachtime: howmachtime,
    );
  }
}
