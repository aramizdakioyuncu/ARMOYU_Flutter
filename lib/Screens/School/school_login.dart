// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/school.dart';
import 'package:ARMOYU/Widgets/buttons.dart';

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

class SchoolLoginPage extends StatefulWidget {
  // GroupCreatePage({});
  @override
  _SchoolLoginPagetate createState() => _SchoolLoginPagetate();
}

class _SchoolLoginPagetate extends State<SchoolLoginPage>
    with AutomaticKeepAliveClientMixin<SchoolLoginPage> {
  @override
  bool get wantKeepAlive => true;

  int _selectedcupertinolist = 0;

  CustomButtons buttons = CustomButtons();
  bool groupcreateProcess = false;

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
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["ID"].toString(),
        'value': element["Value"],
        'logo': element["okul_ufaklogo"]
      });
    }
  }

  Future<void> loginschool() async {}

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
        title: Text("Grup Oluştur"),
        backgroundColor: Colors.black,
      ), // Set the AppBar to null if it should be hidden

      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              CachedNetworkImage(
                imageUrl: Schoollogo,
                width: ARMOYU.screenWidth * 0.8,
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
              asa.Costum1("Parola", schoolpassword, true, Icon(Icons.security)),
              SizedBox(height: 16),
              buttons.Costum1("Katıl", loginschool, groupcreateProcess),
            ],
          ),
        ),
      ),
    );
  }
}
