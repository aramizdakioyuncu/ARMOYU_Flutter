import 'package:armoyu/app/modules/Business/bussiness_module.dart';
import 'package:armoyu/app/modules/Events/event_module.dart';
import 'package:armoyu/app/modules/Invite/invite_page/invite_module.dart';
import 'package:armoyu/app/modules/LoginRegister/resetpassword_page/resetpassword_module.dart';
import 'package:armoyu/app/modules/Restourant/restourant_page/restourant_module.dart';
import 'package:armoyu/app/modules/School/school_module.dart';
import 'package:armoyu/app/modules/Settings/settings_module.dart';
import 'package:armoyu/app/modules/Social/socail_module.dart';
import 'package:armoyu/app/modules/Story/story_module.dart';
import 'package:armoyu/app/modules/pages/chatpage/call_chat_page/chatcall_module.dart';
import 'package:armoyu/app/modules/poll/poll_module.dart';
import 'package:armoyu/app/modules/utils/camera/cam_module.dart';
import 'package:armoyu/app/modules/pages/chatpage/detail_chat_page/chatdetail_module.dart';
import 'package:armoyu/app/modules/Group/group_module.dart';
import 'package:armoyu/app/modules/LoginRegister/loginregister_module.dart';
import 'package:armoyu/app/modules/News/list_news_page/module.dart';
import 'package:armoyu/app/modules/News/news_page/module.dart';
import 'package:armoyu/app/modules/pages/mainpage/Notification/friend_request_page/friend_requst_module.dart';
import 'package:armoyu/app/modules/pages/mainpage/Notification/group_request_page/group_request_module.dart';
import 'package:armoyu/app/modules/pages/mainpage/Profile/friends_page/profile_friendlist_module.dart';
import 'package:armoyu/app/modules/pages/mainpage/Profile/profile_page/module.dart';
import 'package:armoyu/app/modules/utils/noconnectionpage/noconnection_module.dart';
import 'package:armoyu/app/modules/utils/startingpage/startingpage_module.dart';
import 'package:armoyu/app/modules/apppage/app_page_module.dart';

class AppRoutes {
  static const initial = StartingpageModule.route;
}

class AppPages {
  static const initial = StartingpageModule.route;

  static final routes = [
    ...AppPageModule.routes,

    //Camera
    ...CamModule.routes,

    //Event
    ...EventModule.routes,

    //Utils
    ...StartingpageModule.routes,
    ...NoconnectionpageModule.routes,

    //Chat
    ...ChatdetailModule.routes,
    ...ChatcallModule.routes,

    //School
    ...SchoolModule.routes,

    //Group
    ...GroupModule.routes,

    //Bussiness
    ...BussinessModule.routes,

    //Survey
    ...PollModule.routes,

    //Invite
    ...InviteModule.routes,

    //Restourant
    ...RestourantModule.routes,
    //News
    ...ListNewsModule.routes,
    ...NewsPageModule.routes,

    //Login Register Password
    ...LoginRegisterpageModule.routes,
    ...ResetPasswordModule.routes,

    //Social
    ...SocailModule.routes,

    //Story
    ...StoryModule.routes,

    //Notifications
    ...GroupRequestModule.routes,
    ...FriendRequstModule.routes,

    //Profile
    ...ProfileModule.routes,
    ...ProfileFriendlistModule.routes,

    //Settings
    ...SettingsModule.routes,
  ];
}
