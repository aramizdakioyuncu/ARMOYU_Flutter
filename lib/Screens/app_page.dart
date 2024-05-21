import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    super.key,
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

    pagesViewList.add(Pages(currentUser: ARMOYU.appUsers[0]));
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  fetchcangedprofiledata(int value) async {
    FunctionService f = FunctionService();

    User? userInfo = await f.fetchUserInfo(
      userID: ARMOYU.appUsers[value].userID!,
    );
    if (userInfo != null) {
      userInfo.password = ARMOYU.appUsers[value].password;
      ARMOYU.appUsers[value] = userInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pagescontroller,
            onPageChanged: (value) {
              fetchcangedprofiledata(value);
            },
            children: pagesViewList,
          ),
        ),
      ),
    );
  }
}
