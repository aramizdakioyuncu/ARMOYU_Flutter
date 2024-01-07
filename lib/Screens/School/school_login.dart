// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/school.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/notifications.dart';

import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

const double _kItemExtent = 32.0;
List<Map<String, String>> cupertinolist = [
  {
    'ID': '-1',
    'value': 'Seç',
    'logo': "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"
  }
];
List<Map<String, String>> cupertinolist2 = [
  {
    'ID': '-1',
    'value': 'Sınıf Seç',
  }
];

class SchoolLoginPage extends StatefulWidget {
  // GroupCreatePage({});
  @override
  _SchoolLoginPagetate createState() => _SchoolLoginPagetate();
}

class _SchoolLoginPagetate extends State<SchoolLoginPage>
    with AutomaticKeepAliveClientMixin<SchoolLoginPage> {
  @override
  bool get wantKeepAlive => true;

  bool SchoolProcess = false;
  int _selectedcupertinolist = 0;
  int _selectedcupertinolist2 = 0;

  CustomButtons buttons = CustomButtons();

  String Schoollogo = "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png";
  @override
  void initState() {
    super.initState();

    getschools(cupertinolist);
  }

  Future<void> _handleRefresh() async {}

  Future<void> getschools(List<Map<String, String>> listname) async {
    FunctionsSchool f = FunctionsSchool();
    Map<String, dynamic> response = await f.getschools();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    listname.add({'ID': "-1", 'value': "Okul Seç", 'logo': Schoollogo});
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["ID"].toString(),
        'value': element["Value"],
        'logo': element["okul_ufaklogo"]
      });
    }
  }

  Future<void> getschoolclass(
      String schoolID, List<Map<String, String>> listname) async {
    FunctionsSchool f = FunctionsSchool();

    log(schoolID);
    Map<String, dynamic> response = await f.getschoolclass(schoolID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    listname.add({
      'ID': "-1",
      'value': "Sınıf Seç",
    });

    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["ID"].toString(),
        'value': element["Value"],
      });
    }
  }

  Future<void> loginschool() async {
    if (SchoolProcess) {
      return;
    }
    SchoolProcess = true;
    FunctionsSchool f = FunctionsSchool();
    String? schoolID = cupertinolist[_selectedcupertinolist]["ID"];
    String? classID = cupertinolist2[_selectedcupertinolist2]["ID"];
    String? jobID = "123";
    String classPassword = schoolpassword.text;

    Map<String, dynamic> response =
        await f.joinschool(schoolID!, classID!, jobID, classPassword);

    String gelenyanit = response["aciklama"];
    if (mounted) {
      CustomNotifications.stackbarNotification(context, gelenyanit);
    }

    if (response["durum"] == 1) {
      Navigator.of(context).pop();
    }
    SchoolProcess = false;
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  TextEditingController schoolpassword = TextEditingController();

  CustomTextfields asa = CustomTextfields();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Okul Seçim"),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              CachedNetworkImage(
                imageUrl: Schoollogo,
                height: 250,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedcupertinolist,
                      ),
                      onSelectedItemChanged: (int selectedItem) async {
                        setState(() {
                          _selectedcupertinolist = selectedItem;

                          try {
                            Schoollogo = cupertinolist[_selectedcupertinolist]
                                    ["logo"]
                                .toString();

                            Timer(Duration(milliseconds: 700), () async {
                              if (_selectedcupertinolist.toString() !=
                                  selectedItem.toString()) {
                                // isProcces = false;
                                return;
                              }

                              getschoolclass(
                                  cupertinolist[_selectedcupertinolist]["ID"]!,
                                  cupertinolist2);

                              // isProcces = false;
                            });
                          } catch (e) {}
                        });
                      },
                      children: List<Widget>.generate(cupertinolist.length,
                          (int index) {
                        return Center(
                            child:
                                Text(cupertinolist[index]["value"].toString()));
                      }),
                    ),
                  );
                },
                child: Container(
                  width: ARMOYU.screenWidth - 10,
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey.shade900,
                  child: Text(
                    cupertinolist[_selectedcupertinolist]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedcupertinolist2,
                      ),
                      onSelectedItemChanged: (int selectedItem) async {
                        setState(() {
                          _selectedcupertinolist2 = selectedItem;
                        });
                      },
                      children: List<Widget>.generate(cupertinolist2.length,
                          (int index) {
                        return Center(
                            child: Text(
                                cupertinolist2[index]["value"].toString()));
                      }),
                    ),
                  );
                },
                child: Container(
                  width: ARMOYU.screenWidth - 10,
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey.shade900,
                  child: Text(
                    cupertinolist2[_selectedcupertinolist2]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              asa.Costum1("Parola", schoolpassword, true, Icon(Icons.security),
                  TextInputType.number),
              SizedBox(height: 16),
              buttons.Costum1("Katıl", loginschool, SchoolProcess),
            ],
          ),
        ),
      ),
    );
  }
}
