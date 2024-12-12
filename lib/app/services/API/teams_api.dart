import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class TeamsAPI {
  final User currentUser;
  TeamsAPI({required this.currentUser});

  Future<TeamListResponse> fetch() async {
    return await API.service.teamsServices.fetch();
  }
}
