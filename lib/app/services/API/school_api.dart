import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class SchoolAPI {
  final User currentUser;
  SchoolAPI({required this.currentUser});

  Future<Map<String, dynamic>> getschools() async {
    return await API.service.schoolServices.getschools(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> fetchSchool({
    required int schoolID,
  }) async {
    return await API.service.schoolServices.fetchSchool(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      schoolID: schoolID,
    );
  }

  Future<Map<String, dynamic>> joinschool({
    required String schoolID,
    required String classID,
    required String jobID,
    required String classPassword,
  }) async {
    return await API.service.schoolServices.joinschool(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      schoolID: schoolID,
      classID: classID,
      jobID: jobID,
      classPassword: classPassword,
    );
  }

  Future<Map<String, dynamic>> getschoolclass({
    required String schoolID,
  }) async {
    return await API.service.schoolServices.getschoolclass(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      schoolID: schoolID,
    );
  }
}
