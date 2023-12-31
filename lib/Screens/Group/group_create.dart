// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/group.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Functions/API_Functions/category.dart';
import 'package:ARMOYU/Widgets/notifications.dart';
import 'package:ARMOYU/Widgets/textfields.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

const double _kItemExtent = 32.0;
List<Map<String, String>> cupertinolist = [
  {'ID': '-1', 'value': 'Seç'}
];
List<Map<String, String>> cupertinolist2 = [
  {'ID': '-1', 'value': 'Seç'}
];
List<Map<String, String>> cupertinolist3 = [
  {'ID': '-1', 'value': 'Seç'}
];

class GroupCreatePage extends StatefulWidget {
  // GroupCreatePage({});
  @override
  _GroupCreatePageState createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage>
    with AutomaticKeepAliveClientMixin<GroupCreatePage> {
  @override
  bool get wantKeepAlive => true;

  int _selectedcupertinolist = 0;
  int _selectedcupertinolist2 = 0;
  int _selectedcupertinolist3 = 0;
  CustomButtons buttons = CustomButtons();

  bool groupcreateProcess = false;

  bool isProcces = false;
  @override
  void initState() {
    super.initState();

    groupcreaterequest("gruplar", cupertinolist);
    groupdetailfetch("E-spor", cupertinolist2);
    groupcreaterequest("E-spor", cupertinolist3);
  }

  Future<void> _handleRefresh() async {}

  Future<void> groupcreaterequest(
      String category, List<Map<String, String>> listname) async {
    FunctionsCategory f = FunctionsCategory();
    Map<String, dynamic> response = await f.category(category);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["kategori_ID"].toString(),
        'value': element["kategori_adi"]
      });
    }
  }

  Future<void> groupdetailfetch(
      String data, List<Map<String, String>> listname) async {
    FunctionsCategory f = FunctionsCategory();
    Map<String, dynamic> response = await f.categorydetail(data);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["kategori_ID"].toString(),
        'value': element["kategori_adi"]
      });
    }
  }

  Future<void> creategroupfunction() async {
    if (groupcreateProcess) {
      return;
    }
    groupcreateProcess = true;
    FunctionsGroup f = FunctionsGroup();
    Map<String, dynamic> response = await f.groupcreate(
        groupname.text,
        groupshortname.text,
        _selectedcupertinolist,
        _selectedcupertinolist2,
        _selectedcupertinolist3);
    if (response["durum"] == 0) {
      String text = response["aciklama"];
      CustomNotifications.stackbarNotification(context, text);
      groupcreateProcess = false;

      return;
    }
    groupcreateProcess = false;
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

  TextEditingController groupshortname = TextEditingController();
  TextEditingController groupname = TextEditingController();

  CustomTextfields asa = CustomTextfields();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grup Oluştur"),
        backgroundColor: Colors.black,
      ), // Set the AppBar to null if it should be hidden

      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              asa.Costum1("Grup Adı", groupname, false, Icon(Icons.business)),
              SizedBox(height: 16),
              asa.Costum1(
                  "Grup Kısa Adı", groupshortname, false, Icon(Icons.label)),
              SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (isProcces) {
                    return;
                  }

                  isProcces = true;
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
                        });

                        Timer(Duration(milliseconds: 700), () async {
                          if (_selectedcupertinolist.toString() !=
                              selectedItem.toString()) {
                            isProcces = false;
                            return;
                          }

                          groupdetailfetch(
                              cupertinolist[selectedItem]["ID"].toString(),
                              cupertinolist2);

                          if (cupertinolist[selectedItem]["value"].toString() ==
                              "E-spor") {
                            groupcreaterequest("E-spor", cupertinolist3);
                            isProcces = false;

                            return;
                          }
                          if (cupertinolist[selectedItem]["value"].toString() ==
                              "Spor") {
                            groupcreaterequest("Spor", cupertinolist3);
                            isProcces = false;

                            return;
                          }
                          if (cupertinolist[selectedItem]["value"].toString() ==
                              "Yazılım & Geliştirme") {
                            groupcreaterequest("projeler", cupertinolist3);
                            isProcces = false;

                            return;
                          }
                          isProcces = false;
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
                onPressed: () => _showDialog(
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
                          child:
                              Text(cupertinolist2[index]["value"].toString()));
                    }),
                  ),
                ),
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
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: _kItemExtent,
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedcupertinolist3,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedcupertinolist3 = selectedItem;
                      });
                    },
                    children: List<Widget>.generate(cupertinolist3.length,
                        (int index) {
                      return Center(
                          child:
                              Text(cupertinolist3[index]["value"].toString()));
                    }),
                  ),
                ),
                child: Container(
                  width: ARMOYU.screenWidth - 10,
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey.shade900,
                  child: Text(
                    cupertinolist3[_selectedcupertinolist3]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              buttons.Costum1(
                  "Oluştur", creategroupfunction, groupcreateProcess),
            ],
          ),
        ),
      ),
    );
  }
}
