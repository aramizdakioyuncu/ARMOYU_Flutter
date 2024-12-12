import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class CountryAPI {
  final User currentUser;
  CountryAPI({required this.currentUser});

  Future<CountryResponse> fetch() async {
    return await API.service.countryServices.countryfetch();
  }

  Future<ProvinceResponse> fetchprovince({required int countryID}) async {
    return await API.service.countryServices
        .fetchprovince(countryID: countryID);
  }
}
