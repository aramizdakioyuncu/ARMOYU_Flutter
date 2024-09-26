import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';

class Station {
  final int stationID;
  final String name;
  final String type;
  final Media logo;
  final Media banner;
  List<StationEquipment> products = [];

  Station({
    required this.stationID,
    required this.name,
    required this.type,
    required this.logo,
    required this.banner,
    this.products = const [],
  });

// Convert Station instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'stationID': stationID,
      'name': name,
      'type': type,
      'logo': logo.toJson(),
      'banner': banner.toJson(),
      'products': products.map((equipment) => equipment.toJson()).toList(),
    };
  }

  // Convert JSON to Station instance
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationID: json['stationID'],
      name: json['name'],
      type: json['type'],
      logo: Media.fromJson(json['logo']),
      banner: Media.fromJson(json['banner']),
      products: (json['products'] as List<dynamic>)
          .map((equipment) => StationEquipment.fromJson(equipment))
          .toList(),
    );
  }
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
  // Convert StationEquipment instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'productsID': productsID,
      'name': name,
      'logo': logo.toJson(),
      'banner': banner.toJson(),
      'price': price,
    };
  }

  // Convert JSON to StationEquipment instance
  factory StationEquipment.fromJson(Map<String, dynamic> json) {
    return StationEquipment(
      productsID: json['productsID'],
      name: json['name'],
      logo: Media.fromJson(json['logo']),
      banner: Media.fromJson(json['banner']),
      price: json['price'],
    );
  }
}
