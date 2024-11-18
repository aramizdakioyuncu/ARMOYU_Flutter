import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class CountryAPI {
  final User currentUser;
  CountryAPI({required this.currentUser});

  Future<Map<String, dynamic>> fetch() async {
    return await API.service.countryServices.countryfetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> fetchprovince({
    required int countryID,
  }) async {
    return await API.service.countryServices.fetchprovince(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      countryID: countryID,
    );
  }
}
