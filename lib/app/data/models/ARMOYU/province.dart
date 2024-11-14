class Province {
  final int provinceID;
  String name;
  int plateCode;
  int phoneCode;
  Province({
    required this.provinceID,
    required this.name,
    required this.plateCode,
    required this.phoneCode,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      provinceID: json['provinceID'],
      name: json['name'],
      plateCode: json['plateCode'],
      phoneCode: json['phoneCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provinceID': provinceID,
      'name': name,
      'plateCode': plateCode,
      'phoneCode': phoneCode,
    };
  }
}
