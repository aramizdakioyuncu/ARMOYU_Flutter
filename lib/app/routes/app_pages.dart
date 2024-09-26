import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/module.dart';
import 'package:ARMOYU/app/modules/Group/create_group_page/module.dart';
import 'package:ARMOYU/app/modules/Group/group_page/module.dart';
import 'package:ARMOYU/app/modules/LoginRegister/loginregister_module.dart';
import 'package:ARMOYU/app/modules/News/list_news_page/module.dart';
import 'package:ARMOYU/app/modules/News/news_page/module.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/module.dart';
import 'package:ARMOYU/app/modules/Utility/noconnectionpage/noconnection_module.dart';
import 'package:ARMOYU/app/modules/Utility/startingpage/startingpage_module.dart';
import 'package:ARMOYU/app/modules/apppage/app_page_module.dart';

class AppPages {
  static const initial = StartingpageModule.route;

  static final routes = [
    ...StartingpageModule.routes,
    ...LoginRegisterpageModule.routes,
    ...NoconnectionpageModule.routes,
    ...AppPageModule.routes,
    ...ListNewsModule.routes,
    ...NewsPageModule.routes,
    ...GroupCreateModule.routes,
    ...GroupPageModule.routes,
    ...ProfileModule.routes,
    ...ChatdetailModule.routes
  ];
}
