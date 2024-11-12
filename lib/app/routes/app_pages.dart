import 'package:ARMOYU/app/modules/Business/bussiness_module.dart';
import 'package:ARMOYU/app/modules/Invite/invite_page/invite_module.dart';
import 'package:ARMOYU/app/modules/LoginRegister/resetpassword_page/resetpassword_module.dart';
import 'package:ARMOYU/app/modules/Restourant/restourant_page/restourant_module.dart';
import 'package:ARMOYU/app/modules/School/school_module.dart';
import 'package:ARMOYU/app/modules/Settings/settings_module.dart';
import 'package:ARMOYU/app/modules/Social/socail_module.dart';
import 'package:ARMOYU/app/modules/Story/story_module.dart';
import 'package:ARMOYU/app/modules/poll/poll_module.dart';
import 'package:ARMOYU/app/modules/utils/camera/cam_module.dart';
import 'package:ARMOYU/app/modules/utils/gallery/gallery_module.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/module.dart';
import 'package:ARMOYU/app/modules/Group/group_module.dart';
import 'package:ARMOYU/app/modules/LoginRegister/loginregister_module.dart';
import 'package:ARMOYU/app/modules/News/list_news_page/module.dart';
import 'package:ARMOYU/app/modules/News/news_page/module.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/friend_request_page/friend_requst_module.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/group_request_page/group_request_module.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/friends_page/profile_friendlist_module.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/module.dart';
import 'package:ARMOYU/app/modules/utils/noconnectionpage/noconnection_module.dart';
import 'package:ARMOYU/app/modules/utils/startingpage/startingpage_module.dart';
import 'package:ARMOYU/app/modules/apppage/app_page_module.dart';

class AppPages {
  static const initial = StartingpageModule.route;

  static final routes = [
    ...AppPageModule.routes,

    //Camera
    ...CamModule.routes,

    //Utils
    ...GalleryModule.routes,
    ...StartingpageModule.routes,
    ...NoconnectionpageModule.routes,

    //Chat
    ...ChatdetailModule.routes,

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
