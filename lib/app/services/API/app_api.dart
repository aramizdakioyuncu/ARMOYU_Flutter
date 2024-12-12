import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class AppAPI {
  final User currentUser;
  AppAPI({required this.currentUser});

  Future<SitemessageResponse> sitemesaji() async {
    return await API.service.appServices.sitemesaji();
  }
}
