import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class TeamsAPI {
  final User currentUser;
  TeamsAPI({required this.currentUser});

  Future<Map<String, dynamic>> fetch() async {
    return await API.service.teamsServices.fetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }
}
