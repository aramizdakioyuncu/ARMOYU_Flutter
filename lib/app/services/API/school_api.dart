import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

class SchoolAPI {
  final User currentUser;
  SchoolAPI({required this.currentUser});

  Future<SchoolFetchListResponse> getschools() async {
    return await API.service.schoolServices.getschools();
  }

  Future<SchoolFetchDetailResponse> fetchSchool({required int schoolID}) async {
    return await API.service.schoolServices.fetchSchool(schoolID: schoolID);
  }

  Future<ServiceResult> joinschool({
    required String schoolID,
    required String classID,
    required String jobID,
    required String classPassword,
  }) async {
    return await API.service.schoolServices.joinWorkstation(
      workstationID: schoolID,
      classID: classID,
      jobID: jobID,
      classPassword: classPassword,
    );
  }

  Future<StationFetchDetailResponse> getschoolclass(
      {required String schoolID}) async {
    return await API.service.schoolServices
        .fetchWorkstationDetail(workStationID: schoolID);
  }
}
