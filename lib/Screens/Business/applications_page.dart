import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/joinus.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Business/joinus_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessApplicationsPage extends StatefulWidget {
  final User currentUser;
  const BusinessApplicationsPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<BusinessApplicationsPage> createState() => _SettingsPage();
}

List _applicationList = [];
int _page = 1;
bool _requestProccess = false;

class _SettingsPage extends State<BusinessApplicationsPage> {
  @override
  void initState() {
    super.initState();

    if (_applicationList.isEmpty) {
      fetchapplicationInfo();
    }
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchapplicationInfo({bool firstpage = false}) async {
    if (firstpage) {
      _applicationList.clear();
      _page = 1;
    }
    if (_requestProccess) {
      return;
    }
    _requestProccess = true;
    setstatefunction();
    FunctionsJoinUs f = FunctionsJoinUs(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.applicationList(_page);

    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      _requestProccess = false;
      setstatefunction();
      return;
    }

    for (var departmentInfo in response["icerik"]) {
      _applicationList.add(
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.star_outline_sharp),
          title: CustomText.costum1(
            departmentInfo["sapplication_position"]["position_name"],
          ),
          subtitle: CustomText.costum1(
            departmentInfo["sapplication_position"]["position_department"],
            color: ARMOYU.textColor.withOpacity(0.6),
          ),
          trailing: departmentInfo["sapplication_status"] == 2
              ? CustomText.costum1("İnceleniyor")
              : departmentInfo["sapplication_status"] == 1
                  ? CustomText.costum1("Kabul Edildi")
                  : departmentInfo["sapplication_status"] == 0
                      ? CustomText.costum1("Reddedildi")
                      : null,
        ),
      );
    }
    _page++;
    _requestProccess = false;
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        title: CustomText.costum1('Bize Katıl'),
        backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async => await fetchapplicationInfo(firstpage: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _requestProccess || _applicationList.isEmpty
          ? Center(
              child: !_requestProccess
                  ? CustomText.costum1("Boş")
                  : const CupertinoActivityIndicator(),
            )
          : ListView.builder(
              itemCount: _applicationList.length,
              itemBuilder: (context, index) {
                return _applicationList[index];
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JoinUsPage(currentUser: widget.currentUser),
          ));
        },
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
