import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class BlockingAPI {
  final User currentUser;
  BlockingAPI({required this.currentUser});

  Future<Map<String, dynamic>> list() async {
    return await API.service.blockingServices.list(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> add({required int userID}) async {
    final result = await API.service.blockingServices.add(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
    return result;
  }

  Future<Map<String, dynamic>> remove({required int userID}) async {
    return await API.service.blockingServices.remove(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }
}
