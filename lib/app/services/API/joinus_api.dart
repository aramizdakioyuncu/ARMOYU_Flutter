import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class JoinusAPI {
  final User currentUser;
  JoinusAPI({required this.currentUser});
//////////////////////JOINUS////////////////////
  Future<Map<String, dynamic>> fetchdepartment() async {
    return await API.service.joinusServices.fetchdepartment(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> applicationList({
    required int page,
  }) async {
    return await API.service.joinusServices.applicationList(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> requestjoindepartment({
    required int positionID,
    required String whyjoin,
    required String whyposition,
    required String howmachtime,
  }) async {
    return await API.service.joinusServices.requestjoindepartment(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      positionID: positionID,
      whyjoin: whyjoin,
      whyposition: whyposition,
      howmachtime: howmachtime,
    );
  }
}
