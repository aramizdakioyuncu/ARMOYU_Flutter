import 'package:ARMOYU/Models/ARMOYU/province.dart';

class Country {
  final int countryID;
  final String name;
  final String countryCode;
  final int phoneCode;
  List<Province>? provinceList;

  Country({
    required this.countryID,
    required this.name,
    required this.countryCode,
    required this.phoneCode,
  });
}
