import 'package:ARMOYU/Models/media.dart';

class Station {
  final int stationID;
  final String name;
  final Media logo;
  final Media banner;
  List<StationEquipment> products = [];

  Station({
    required this.stationID,
    required this.name,
    required this.logo,
    required this.banner,
  });
}

class StationEquipment {
  final int productsID;
  final String name;
  final Media logo;
  final Media banner;
  final String price;

  StationEquipment({
    required this.productsID,
    required this.name,
    required this.logo,
    required this.banner,
    required this.price,
  });
}
