import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/team.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/news.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class UserAccounts {
  User user;
  //Sosyal KISIM
  List<Post>? widgetPosts;
  List<StoryList>? widgetStoriescard;
  List<Post>? widgettaggedPosts;

  List<Post>? lastsharingpost;

  List<Chat>? chatList = [];
  List<News>? newsList = [];

  List<User>? searchList = [];

  List<User>? notificationList = [];
  List<User>? lastviewusersList = [];
  List<Group>? lastviewgroupsList = [];
  List<School>? lastviewschoolsList = [];
  List<Station>? lastviewstationsList = [];

  int chatNotificationCount = 0;
  int surveyNotificationCount = 0;
  int eventsNotificationCount = 0;
  int downloadableCount = 0;

  int friendRequestCount = 0;
  int groupInviteCount = 0;

  //Takım Seçme işlemleri
  List<Team>? favoriteteams = [];
  Map<String, dynamic>? favTeam = {};
  bool favteamRequest = false;

  UserAccounts({
    required this.user,
    this.widgetPosts,
    this.widgetStoriescard,
    this.widgettaggedPosts,
    this.lastsharingpost,
    this.chatList,
    this.newsList,
    this.searchList,
    this.notificationList,
    this.lastviewusersList,
    this.lastviewgroupsList,
    this.lastviewschoolsList,
    this.lastviewstationsList,
    this.chatNotificationCount = 0,
    this.surveyNotificationCount = 0,
    this.eventsNotificationCount = 0,
    this.downloadableCount = 0,
    this.friendRequestCount = 0,
    this.groupInviteCount = 0,
    this.favoriteteams,
    this.favTeam,
    this.favteamRequest = false,
  });

  get value => null;

  // Convert UserAccounts instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'widgetPosts': widgetPosts?.map((post) => post.toJson()).toList(),
      'widgetStoriescard':
          widgetStoriescard?.map((story) => story.toJson()).toList(),
      'widgettaggedPosts':
          widgettaggedPosts?.map((post) => post.toJson()).toList(),
      'lastsharingpost': lastsharingpost?.map((post) => post.toJson()).toList(),
      'chatList': chatList?.map((chat) => chat.toJson()).toList(),
      'newsList': newsList?.map((news) => news.toJson()).toList(),
      'searchList': searchList?.map((user) => user.toJson()).toList(),
      'notificationList':
          notificationList?.map((user) => user.toJson()).toList(),
      'lastviewusersList':
          lastviewusersList?.map((user) => user.toJson()).toList(),
      'lastviewgroupsList':
          lastviewgroupsList?.map((group) => group.toJson()).toList(),
      'lastviewschoolsList':
          lastviewschoolsList?.map((school) => school.toJson()).toList(),
      'lastviewstationsList':
          lastviewstationsList?.map((station) => station.toJson()).toList(),
      'chatNotificationCount': chatNotificationCount,
      'surveyNotificationCount': surveyNotificationCount,
      'eventsNotificationCount': eventsNotificationCount,
      'downloadableCount': downloadableCount,
      'friendRequestCount': friendRequestCount,
      'groupInviteCount': groupInviteCount,
      'favoriteteams': favoriteteams?.map((team) => team.toJson()).toList(),
      'favTeam': favTeam,
      'favteamRequest': favteamRequest,
    };
  }

  // Convert JSON to UserAccounts instance
  factory UserAccounts.fromJson(Map<String, dynamic> json) {
    return UserAccounts(
      user: User.fromJson(json['user']),
      widgetPosts: (json['widgetPosts'] as List<dynamic>?)
          ?.map((post) => Post.fromJson(post))
          .toList(),
      widgetStoriescard: (json['widgetStoriescard'] as List<dynamic>?)
          ?.map((story) => StoryList.fromJson(story))
          .toList(),
      widgettaggedPosts: (json['widgettaggedPosts'] as List<dynamic>?)
          ?.map((post) => Post.fromJson(post))
          .toList(),
      lastsharingpost: (json['lastsharingpost'] as List<dynamic>?)
          ?.map((post) => Post.fromJson(post))
          .toList(),
      chatList: (json['chatList'] as List<dynamic>?)
          ?.map((chat) => Chat.fromJson(chat))
          .toList(),
      newsList: (json['newsList'] as List<dynamic>?)
          ?.map((news) => News.fromJson(news))
          .toList(),
      searchList: (json['searchList'] as List<dynamic>?)
          ?.map((user) => User.fromJson(user))
          .toList(),
      notificationList: (json['notificationList'] as List<dynamic>?)
          ?.map((user) => User.fromJson(user))
          .toList(),
      lastviewusersList: (json['lastviewusersList'] as List<dynamic>?)
          ?.map((user) => User.fromJson(user))
          .toList(),
      lastviewgroupsList: (json['lastviewgroupsList'] as List<dynamic>?)
          ?.map((group) => Group.fromJson(group))
          .toList(),
      lastviewschoolsList: (json['lastviewschoolsList'] as List<dynamic>?)
          ?.map((school) => School.fromJson(school))
          .toList(),
      lastviewstationsList: (json['lastviewstationsList'] as List<dynamic>?)
          ?.map((station) => Station.fromJson(station))
          .toList(),
      chatNotificationCount: json['chatNotificationCount'] ?? 0,
      surveyNotificationCount: json['surveyNotificationCount'] ?? 0,
      eventsNotificationCount: json['eventsNotificationCount'] ?? 0,
      downloadableCount: json['downloadableCount'] ?? 0,
      friendRequestCount: json['friendRequestCount'] ?? 0,
      groupInviteCount: json['groupInviteCount'] ?? 0,
      favoriteteams: (json['favoriteteams'] as List<dynamic>?)
              ?.map((team) => Team.fromJson(team))
              .toList() ??
          [],
      favTeam: json['favTeam'] ?? {},
      favteamRequest: json['favteamRequest'] ?? false,
    );
  }

  void updateUser({required User targetUser}) {
    user.updateUser(targetUser: targetUser);
  }
}
