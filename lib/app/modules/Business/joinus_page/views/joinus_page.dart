import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/API_Functions/joinus.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:flutter/material.dart';

class JoinUsBusinessView extends StatefulWidget {
  final User currentUser;

  const JoinUsBusinessView({
    super.key,
    required this.currentUser,
  });

  @override
  State<JoinUsBusinessView> createState() => _SettingsPage();
}

List<Map<int, dynamic>> _departmentList = [];
List<Map<int, dynamic>> _departmentdetailList = [];
List<Map<int, dynamic>> _filtereddepartmentdetailList = [];

class _SettingsPage extends State<JoinUsBusinessView> {
  final TextEditingController _whyjointheteamController =
      TextEditingController();
  final TextEditingController _whypositionController = TextEditingController();
  final TextEditingController _howmuchtimedoyouspareController =
      TextEditingController();

  String? _category;
  String? _categorydetail;
  int? _positionID;
  String departmentabout = "";
  bool requestProccess = false;
  @override
  void initState() {
    super.initState();

    if (_departmentList.isEmpty) {
      fetchdepartmentInfo();
    }
  }

  Future<void> requestjoinfunction() async {
    if (_positionID == null) {
      return;
    }

    if (requestProccess) {
      return;
    }

    if (_whyjointheteamController.text.length < 20 ||
        200 < _whyjointheteamController.text.length) {
      ARMOYUWidget.stackbarNotification(
          context, "neden ekibe katılmak istiyorsun yetersiz girilmiş!");
      return;
    }

    if (_whypositionController.text.length < 10 ||
        100 < _whypositionController.text.length) {
      ARMOYUWidget.stackbarNotification(
          context, "Neden bu yetkiyi seçtin yetersiz girilmiş!");
      return;
    }

    if (_howmuchtimedoyouspareController.text.length < 5 ||
        50 < _howmuchtimedoyouspareController.text.length) {
      ARMOYUWidget.stackbarNotification(
          context, "Bize kaç gün ayırabilirsin yetersiz girilmiş!");
      return;
    }
    requestProccess = true;
    setstatefunction();

    FunctionsJoinUs f = FunctionsJoinUs(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.requestjoindepartment(
        _positionID!,
        _whyjointheteamController.text,
        _whypositionController.text,
        _howmuchtimedoyouspareController.text);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, response["aciklama"]);
      }
      requestProccess = false;
      setstatefunction();
      return;
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> fetchdepartmentInfo() async {
    FunctionsJoinUs f = FunctionsJoinUs(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.fetchdepartment();

    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    for (var departmentInfo in response["icerik"]) {
      log(departmentInfo["Value"].toString());
      if (departmentInfo["Value"] == "Kurucu") {
        continue;
      }
      if (departmentInfo["category"] != null) {
        if (!_departmentList.any((info) =>
            info.values.first['category'] == departmentInfo['category'])) {
          _departmentList.add({
            departmentInfo["ID"]: {
              "ID": departmentInfo["ID"],
              "category": departmentInfo["category"],
              "value": departmentInfo["Value"],
              "about": departmentInfo["about"],
            },
          });
        }
      }
      _departmentdetailList.add({
        departmentInfo["ID"]: {
          "ID": departmentInfo["ID"],
          "category": departmentInfo["category"],
          "value": departmentInfo["Value"],
          "about": departmentInfo["about"],
        }
      });
    }
    setstatefunction();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        title: CustomText.costum1('Bize Katıl'),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: [
              Container(color: ARMOYU.bodyColor, height: 1),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/armoyu512.png',
                  height: 150,
                  width: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText.costum1(
                  "* Cep telefon numarasını sisteme kayıt etmiş olmak.\n* Profil fotoğrafı varsayılan logodan farklı olmak.\n* Hiç ceza almamış ve insanları kışkırtmamış olmak.",
                  align: TextAlign.left,
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtons.costum2(
                  text: _category != null ? '$_category' : 'Bir Öğe Seçin',
                  onPressed: () {
                    WidgetUtility.cupertinoselector(
                      context: context,
                      title: "Ekip Seçimi",
                      setstatefunction: setstatefunction,
                      list: _departmentList.map((item) {
                        return item.map((key, value) {
                          return MapEntry(key, value["category"].toString());
                        });
                      }).toList(),
                      onChanged: (valueID, value) {
                        if (valueID == -1) {
                          return;
                        }
                        _category = value;

                        _filtereddepartmentdetailList =
                            _departmentdetailList.where((item) {
                          return item.values.first["category"] == _category;
                        }).toList();

                        _categorydetail = "Bir pozisyon Seç";
                        departmentabout = "";
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtons.costum2(
                  text: _categorydetail != null
                      ? '$_categorydetail'
                      : 'Bir pozisyon Seç',
                  onPressed: () {
                    WidgetUtility.cupertinoselector(
                      context: context,
                      title: "Bir pozisyon Seç",
                      setstatefunction: setstatefunction,
                      list: _filtereddepartmentdetailList.map((item) {
                        return item.map((key, value) {
                          return MapEntry(key, value["value"].toString());
                        });
                      }).toList(),
                      onChanged: (valueID, value) {
                        if (valueID == -1) {
                          return;
                        }
                        _categorydetail = value;
                        _positionID = _filtereddepartmentdetailList[valueID]
                            .values
                            .first["ID"];
                        departmentabout = _filtereddepartmentdetailList[valueID]
                            .values
                            .first["about"]
                            .toString();
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText.costum1(
                  departmentabout,
                  align: TextAlign.left,
                  color: Colors.amber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextfields(setstate: setstatefunction).costum3(
                  title: "Neden ekibe katılmak istiyorsun?",
                  minLines: 5,
                  maxLength: 200,
                  minLength: 20,
                  controller: _whyjointheteamController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextfields(setstate: setstatefunction).costum3(
                  title: "Neden bu yetkiyi seçtin?",
                  minLines: 3,
                  maxLength: 100,
                  minLength: 10,
                  controller: _whypositionController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextfields(setstate: setstatefunction).costum3(
                  title: "Bize haftada kaç gün ayırabilirsin?",
                  minLines: 2,
                  maxLength: 50,
                  minLength: 5,
                  controller: _howmuchtimedoyouspareController,
                ),
              ),
              CustomButtons.costum1(
                text: "Gönder",
                onPressed: () async => await requestjoinfunction(),
                loadingStatus: requestProccess,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
