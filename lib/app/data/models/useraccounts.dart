import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/team.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/news.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:get/get.dart';

class UserAccounts {
  Rx<User> user;
  Rx<String> sessionTOKEN;

  Rx<String> language;
  //Sosyal KISIM
  List<Post>? widgetPosts;
  List<StoryList>? widgetStoriescard;
  List<Post>? widgettaggedPosts;

  List<Post>? lastsharingpost;

  RxList<Chat>? chatList;

  List<News>? newsList = [];

  List<User>? searchList = [];

  List<User>? notificationList = [];
  List<User>? lastviewusersList = [];
  List<Group>? lastviewgroupsList = [];
  List<School>? lastviewschoolsList = [];
  List<Station>? lastviewstationsList = [];

  Rx<int> chatNotificationCount = Rx<int>(0);
  Rx<int> surveyNotificationCount = Rx<int>(0);
  Rx<int> eventsNotificationCount = Rx<int>(0);
  Rx<int> downloadableCount = Rx<int>(0);

  Rx<int> friendRequestCount = Rx<int>(0);
  Rx<int> groupInviteCount = Rx<int>(0);

  //Takım Seçme işlemleri
  List<Team>? favoriteteams = [];
  Map<String, dynamic>? favTeam = {};
  bool favteamRequest = false;

  UserAccounts({
    required this.user,
    required this.sessionTOKEN,
    required this.language,
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
    this.favoriteteams,
    this.favTeam,
    this.favteamRequest = false,
    Rx<int>? chatNotificationCount,
    Rx<int>? friendRequestCount,
    Rx<int>? surveyNotificationCount,
    Rx<int>? eventsNotificationCount,
    Rx<int>? downloadableCount,
    Rx<int>? groupInviteCount,
  })  : chatNotificationCount = chatNotificationCount ?? Rx<int>(0),
        surveyNotificationCount = surveyNotificationCount ?? Rx<int>(0),
        eventsNotificationCount = eventsNotificationCount ?? Rx<int>(0),
        downloadableCount = downloadableCount ?? Rx<int>(0),
        friendRequestCount = friendRequestCount ?? Rx<int>(0),
        groupInviteCount = groupInviteCount ?? Rx<int>(0);

  get value => null;

  // Convert UserAccounts instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.value.toJson(),
      'sessionTOKEN': sessionTOKEN.value,
      'language': language.value,
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
      'chatNotificationCount': chatNotificationCount.value,
      'surveyNotificationCount': surveyNotificationCount.value,
      'eventsNotificationCount': eventsNotificationCount.value,
      'downloadableCount': downloadableCount.value,
      'friendRequestCount': friendRequestCount.value,
      'groupInviteCount': groupInviteCount.value,
      'favoriteteams': favoriteteams?.map((team) => team.toJson()).toList(),
      'favTeam': favTeam,
      'favteamRequest': favteamRequest,
    };
  }

  // Convert JSON to UserAccounts instance
  factory UserAccounts.fromJson(Map<String, dynamic> json) {
    return UserAccounts(
      user: User.fromJson(json['user']).obs,
      sessionTOKEN: Rx(json['sessionTOKEN']),
      language: Rx(json['language']),
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
      chatList: json['chatList'] == null
          ? null
          : (json['chatList'] as List<dynamic>?)
              ?.map((chatList) => Chat.fromJson(chatList))
              .toList()
              .obs,
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
      chatNotificationCount: Rx<int>(json['chatNotificationCount']),
      surveyNotificationCount: Rx<int>(json['surveyNotificationCount']),
      eventsNotificationCount: Rx<int>(json['eventsNotificationCount']),
      downloadableCount: Rx<int>(json['downloadableCount']),
      friendRequestCount: Rx<int>(json['friendRequestCount']),
      groupInviteCount: Rx<int>(json['groupInviteCount']),
      favoriteteams: (json['favoriteteams'] as List<dynamic>?)
              ?.map((team) => Team.fromJson(team))
              .toList() ??
          [],
      favTeam: json['favTeam'] ?? {},
      favteamRequest: json['favteamRequest'] ?? false,
    );
  }

  void updateUser({required User targetUser}) {
    user.value.updateUser(targetUser: targetUser);
  }
}
