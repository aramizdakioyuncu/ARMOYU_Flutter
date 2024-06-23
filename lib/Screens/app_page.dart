import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  final int userID;

  const AppPage({
    super.key,
    required this.userID,
  });

  @override
  State<AppPage> createState() => _MainPageState();
}

final List<Pages> pagesViewList = [];
final PageController pagescontroller = PageController(initialPage: 0);

class _MainPageState extends State<AppPage>
    with AutomaticKeepAliveClientMixin<AppPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    User currentUser = ARMOYU.appUsers
        .firstWhere((element) => element.userID == widget.userID);

    pagesViewList.add(
      Pages(
        currentUser: currentUser,
        changeProfileFunction: changeAccount,
      ),
    );

    for (Pages pagaviewInfo in pagesViewList) {
      log("${pagaviewInfo.currentUser.userID!} -> ${pagaviewInfo.currentUser.displayName!}");
    }
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> changeAccount(User selectedUser) async {
    if (!pagesViewList.any(
        (element) => element.currentUser.userID! == selectedUser.userID!)) {
      pagesViewList.add(
        Pages(
          currentUser: selectedUser,
          changeProfileFunction: changeAccount,
        ),
      );
      setstatefunction();
      log("Aktif Hesap Sayısı:${pagesViewList.length - 1} -> ${pagesViewList.length}");
    } else {
      log("Aktif Hesap Sayısı: ${pagesViewList.length}");
    }

    int countPageIndex = pagesViewList.indexWhere(
        (element) => element.currentUser.userID! == selectedUser.userID);

    log("Index Sayaç $countPageIndex");

    if (mounted) {
      Navigator.pop(context);
    }

    pagescontroller.animateToPage(
      countPageIndex,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.ease,
    );

    await fetchChangedprofiledata(selectedUser);
    setstatefunction();
  }

  Future<void> fetchChangedprofiledata(User user) async {
    FunctionService f = FunctionService(currentUser: user);

    User? userInfo = await f.fetchUserInfo(
      userID: user.userID!,
    );
    if (userInfo != null) {
      userInfo.password = user.password;

      userInfo.updateUser(targetUser: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pagescontroller,
          onPageChanged: (value) {},
          children: pagesViewList,
        ),
      ),
    );
  }
}
