import 'dart:async';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/API_Functions/group.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/functions/API_Functions/category.dart';

import 'package:ARMOYU/app/widgets/textfields.dart';

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
  final User currentUser;

  const GroupCreatePage({
    super.key,
    required this.currentUser,
  });

  // GroupCreatePage({});
  @override
  State<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage>
    with AutomaticKeepAliveClientMixin<GroupCreatePage> {
  @override
  bool get wantKeepAlive => true;

  int _selectedcupertinolist = 0;
  int _selectedcupertinolist2 = 0;
  int _selectedcupertinolist3 = 0;

  bool groupcreateProcess = false;

  bool isProcces = false;
  @override
  void initState() {
    super.initState();

    groupcreaterequest("gruplar", cupertinolist);
    groupdetailfetch("E-spor", cupertinolist2);
    groupcreaterequest("E-spor", cupertinolist3);
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleRefresh() async {}

  Future<void> groupcreaterequest(
      String category, List<Map<String, String>> listname) async {
    FunctionsCategory f = FunctionsCategory(currentUser: widget.currentUser);
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
    FunctionsCategory f = FunctionsCategory(currentUser: widget.currentUser);
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
    setState(() {
      groupcreateProcess = true;
    });

    FunctionsGroup f = FunctionsGroup(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.groupcreate(
        groupname.text,
        groupshortname.text,
        _selectedcupertinolist,
        _selectedcupertinolist2,
        _selectedcupertinolist3);
    if (response["durum"] == 0) {
      String text = response["aciklama"];
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, text);
        setState(() {
          groupcreateProcess = false;
        });
      }

      return;
    }
    setState(() {
      groupcreateProcess = false;
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

  TextEditingController groupshortname = TextEditingController();
  TextEditingController groupname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: const Text("Grup Oluştur"),
        backgroundColor: Colors.black,
      ), // Set the AppBar to null if it should be hidden

      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomTextfields(setstate: setstatefunction).costum3(
                title: "Grup Adı",
                controller: groupname,
                isPassword: false,
                preicon: const Icon(Icons.business),
              ),
              const SizedBox(height: 16),
              CustomTextfields(setstate: setstatefunction).costum3(
                title: "Grup Kısa Adı",
                controller: groupshortname,
                isPassword: false,
                preicon: const Icon(Icons.label),
              ),
              const SizedBox(height: 16),
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

                        Timer(const Duration(milliseconds: 700), () async {
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
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey.shade900,
                  child: Text(
                    cupertinolist[_selectedcupertinolist]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey.shade900,
                  child: Text(
                    cupertinolist2[_selectedcupertinolist2]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey.shade900,
                  child: Text(
                    cupertinolist3[_selectedcupertinolist3]["value"].toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButtons.costum1(
                text: "Oluştur",
                onPressed: creategroupfunction,
                loadingStatus: groupcreateProcess,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
