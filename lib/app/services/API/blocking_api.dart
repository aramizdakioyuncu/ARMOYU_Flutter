import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class BlockingAPI {
  final User currentUser;
  BlockingAPI({required this.currentUser});

  Future<BlockingListResponse> list() async {
    return await API.service.blockingServices.list();
  }

  Future<BlockingAddResponse> add({required int userID}) async {
    return await API.service.blockingServices.add(userID: userID);
  }

  Future<BlockingRemoveResponse> remove({required int userID}) async {
    return await API.service.blockingServices.remove(userID: userID);
  }
}
