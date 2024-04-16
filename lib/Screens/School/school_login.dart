import 'dart:async';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/school.dart';
import 'package:ARMOYU/Widgets/buttons.dart';

import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

const double _kItemExtent = 32.0;
List<Map<String, String>> _cupertinolist = [
  {
    'ID': '-1',
    'value': 'Seç',
    'logo': "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"
  }
];
List<Map<String, String>> _cupertinolist2 = [
  {
    'ID': '-1',
    'value': 'Sınıf Seç',
  }
];

class SchoolLoginPage extends StatefulWidget {
  const SchoolLoginPage({super.key});

  @override
  State<SchoolLoginPage> createState() => _SchoolLoginPagetate();
}

class _SchoolLoginPagetate extends State<SchoolLoginPage>
    with AutomaticKeepAliveClientMixin<SchoolLoginPage> {
  @override
  bool get wantKeepAlive => true;

  bool schoolProcess = false;
  int _selectedcupertinolist = 0;
  int _selectedcupertinolist2 = 0;

  String schoollogo = "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png";
  @override
  void initState() {
    super.initState();

    getschools(_cupertinolist);
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
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
    listname.add({'ID': "-1", 'value': "Okul Seç", 'logo': schoollogo});
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
    if (schoolProcess) {
      return;
    }
    setState(() {
      schoolProcess = true;
    });
    FunctionsSchool f = FunctionsSchool();
    String? schoolID = _cupertinolist[_selectedcupertinolist]["ID"];
    String? classID = _cupertinolist2[_selectedcupertinolist2]["ID"];
    String? jobID = "123";
    String classPassword = schoolpassword.text;

    Map<String, dynamic> response =
        await f.joinschool(schoolID!, classID!, jobID, classPassword);

    String gelenyanit = response["aciklama"];
    if (mounted) {
      ARMOYUWidget.stackbarNotification(context, gelenyanit);
    }

    if (response["durum"] == 1) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
    setState(() {
      schoolProcess = false;
    });
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Okul Seçim"),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CachedNetworkImage(
                imageUrl: schoollogo,
                height: 250,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 16),
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
                            schoollogo = _cupertinolist[_selectedcupertinolist]
                                    ["logo"]
                                .toString();

                            Timer(const Duration(milliseconds: 700), () async {
                              if (_selectedcupertinolist.toString() !=
                                  selectedItem.toString()) {
                                // isProcces = false;
                                return;
                              }

                              getschoolclass(
                                  _cupertinolist[_selectedcupertinolist]["ID"]!,
                                  _cupertinolist2);

                              // isProcces = false;
                            });
                          } catch (e) {
                            log(e.toString());
                          }
                        });
                      },
                      children: List<Widget>.generate(_cupertinolist.length,
                          (int index) {
                        return Center(
                          child:
                              Text(_cupertinolist[index]["value"].toString()),
                        );
                      }),
                    ),
                  );
                },
                child: Container(
                  width: ARMOYU.screenWidth - 10,
                  padding: const EdgeInsets.all(16.0),
                  color: ARMOYU.textbackColor,
                  child: Text(
                    _cupertinolist[_selectedcupertinolist]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                      children: List<Widget>.generate(_cupertinolist2.length,
                          (int index) {
                        return Center(
                            child: Text(
                                _cupertinolist2[index]["value"].toString()));
                      }),
                    ),
                  );
                },
                child: Container(
                  width: ARMOYU.screenWidth - 10,
                  padding: const EdgeInsets.all(16.0),
                  color: ARMOYU.textbackColor,
                  child: Text(
                    _cupertinolist2[_selectedcupertinolist2]["value"]
                        .toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextfields(setstate: setstatefunction).costum3(
                title: "Parola",
                controller: schoolpassword,
                isPassword: true,
                preicon: const Icon(Icons.security),
                type: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomButtons.costum1(
                text: "Katıl",
                onPressed: loginschool,
                loadingStatus: schoolProcess,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
