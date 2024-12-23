import 'package:get/get.dart';

class Selection {
  Rxn<int>? selectedIndex;
  List<Select>? list;

  Selection({
    this.selectedIndex,
    this.list,
  });

  // From JSON
  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection(
      selectedIndex: json['selectedIndex'],
      list: json['list'] != null
          ? (json['list'] as List).map((e) => Select.fromJson(e)).toList()
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedIndex': selectedIndex,
      'list': list?.map((e) => e.toJson()).toList(),
    };
  }
}

class Select {
  final int selectID;
  final String title;
  final dynamic value;
  Rx<Selection>? selectionList; // Typo düzeltildi: RxList<Selection>

  Select({
    required this.selectID,
    required this.title,
    required this.value,
    this.selectionList,
  });

  // From JSON
  factory Select.fromJson(Map<String, dynamic> json) {
    return Select(
      selectID: json['selectID'] ?? 0, // Varsayılan bir değer
      title: json['title'] ?? '',
      value: json['value'],
      selectionList: json['selectionList'],
      // selectionList: json['selectionList'] != null
      //     ? (json['selectionList'] as List)
      //         .map((e) => Selection.fromJson(e as Map<String, dynamic>))
      //         .toList()
      //         .obs // RxList<Selection> oluşturmak için
      //     : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'selectID': selectID,
      'title': title,
      'value': value,
      'selectionList': selectionList?.map((e) => e?.toJson()).toList(),
    };
  }
}
