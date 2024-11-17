import 'package:ARMOYU/app/translations/app_translation.dart';

Map<String, String> en = {
  TranslateKeys.currentLanguage: 'English',

  //Common
  CommonKeys.search: "Search",
  CommonKeys.empty: "Empty",
  CommonKeys.join: "Join",
  CommonKeys.leave: "Leave",
  CommonKeys.cancel: "Cancel",
  CommonKeys.submit: "Submit",
  CommonKeys.create: "Create",
  CommonKeys.share: "Share",
  CommonKeys.update: 'Update',
  CommonKeys.save: 'Save',
  CommonKeys.change: 'Change',
  CommonKeys.invite: 'Invite',

  CommonKeys.accept: 'Accept',
  CommonKeys.decline: 'Decline',

  CommonKeys.online: 'Online',
  CommonKeys.offline: 'Offline',

  CommonKeys.calling: 'Calling',

  CommonKeys.second: 'Second',
  CommonKeys.minute: 'Minute',
  CommonKeys.hour: 'Hour',

  CommonKeys.day: 'Day',
  CommonKeys.month: 'Month',
  CommonKeys.year: 'Year',

  CommonKeys.everyone: 'Everyone',
  CommonKeys.friends: 'Friends',

  QuestionKeys.areyousure: 'Are you sure?',
  QuestionKeys.areyousuredetail: 'Are you sure about this process?',
  QuestionKeys.areyousuredetaildescription:
      'This action does not delete your account directly; it queues it. If you do not log into your account within 60 days, it will be automatically deleted by the system.',

  AnswerKeys.yourRequestReceived: 'Your request has been received.',

  //Social
  SocialKeys.socialStory: 'Your Story',
  SocialKeys.socialandnumberpersonLiked: 'and #NUMBER# person liked',
  SocialKeys.socialLiked: 'liked',
  SocialKeys.socialViewAllComments: 'View all comments',

  SocialKeys.socialComments: 'Comments',
  SocialKeys.socialWriteFirstComment: 'Write first comment',
  SocialKeys.socialWriteComment: 'Write comment',

  SocialKeys.socialLikers: 'Likers',

  SocialKeys.socialAddFavorite: 'Add to favorites',
  SocialKeys.socialReport: 'Report',
  SocialKeys.socialBlock: 'Block User',
  SocialKeys.socialedit: 'Edit Post',
  SocialKeys.socialdelete: 'Delete Post',

  SocialKeys.socialShare: 'Share Post',
  SocialKeys.socialwritesomething: 'Write Something',

  //Notification
  NotificationKeys.friendRequests: 'Friend Request',
  NotificationKeys.reviewFriendRequests: 'Review friend requests',
  NotificationKeys.groupRequests: 'Group Requests',
  NotificationKeys.reviewGroupRequests: 'Review group requests',

  //Profile

  ProfileKeys.profilerefresh: 'Refresh Profile',
  ProfileKeys.profileEdit: 'Edit Profile',
  ProfileKeys.profilecopylink: 'Copy Profile Link',
  ProfileKeys.profileblock: 'Block User',
  ProfileKeys.profilereport: 'Report Profile',
  ProfileKeys.profileremovefriend: 'Remove from Friends',
  ProfileKeys.profilepoke: 'Poke',

  ProfileKeys.profilePost: 'Post',
  ProfileKeys.profilefriend: 'Friend',
  ProfileKeys.profileaward: 'Award',

  ProfileKeys.profilePosts: 'Posts',
  ProfileKeys.profileMedia: 'Media',
  ProfileKeys.profileMentions: 'Mention',

  ProfileKeys.profilefirstname: 'First Name',
  ProfileKeys.profilelastname: 'Last Name',
  ProfileKeys.profileaboutme: 'About Me',
  ProfileKeys.profileemail: 'Email',
  ProfileKeys.profilelocation: 'Location',
  ProfileKeys.profilebirthdate: 'Birth Date',
  ProfileKeys.profilephonenumber: 'Phone Number',
  ProfileKeys.profilecheckpassword: 'Check Password',

  ProfileKeys.profileselectcountry: 'Select Country',
  ProfileKeys.profileselectcity: 'Select City',

  //Chat
  ChatKeys.chat: 'Chats',
  ChatKeys.chatyournote: 'Your Note',
  ChatKeys.chatshareasong: 'Share a song',
  ChatKeys.chatnewchat: 'New Chat',
  ChatKeys.chatwritemessage: 'Write message',

  ChatKeys.chatTargetAudience: 'Target audience',

  //Group
  GroupKeys.createGroup: 'Create Group',
  GroupKeys.groupName: 'Group Name',
  GroupKeys.groupShortname: 'Group Shortname',

  GroupKeys.groupkickuser: 'Group kick user',
  GroupKeys.groupInviteuser: 'Group invite user',
  GroupKeys.groupInviteNumberuserSelected: 'Selected number of invited users',
  GroupKeys.groupMember: 'Group member',
  GroupKeys.groupLogo: 'Group logo',
  GroupKeys.groupbanner: 'Group banner',
  GroupKeys.groupdescription: 'Group description',
  GroupKeys.groupwebsite: 'Group website',
  GroupKeys.groupisJoinable: 'Group is joinable',

  //School
  SchoolKeys.joinSchool: 'Join School',
  SchoolKeys.schoolPassword: 'Password',
  SchoolKeys.schoolJoin: 'Join',

  //Food
  FoodKeys.orderExplain: 'Please scan at the checkout to place your order.',
  FoodKeys.foodProduct: 'Product',
  FoodKeys.foodPrice: 'Price',

  //Poll

  PollKeys.createPoll: 'Create Poll',
  PollKeys.pollquestion: 'Poll Question',
  PollKeys.pollanswers: 'Poll Answers',
  PollKeys.pollOption: 'Option',
  PollKeys.pollAddOption: 'Add Option',

  PollKeys.selectHour: 'Select Hour',
  PollKeys.selectDate: 'Select Date',

  PollKeys.selectPollMultipleChoice: 'Multiple Chocie',
  PollKeys.selectPollCheckboxes: 'Check Boxes',
  PollKeys.selectPollShortAnswer: 'Short Answer',

  PollKeys.pollExpired: 'Expired',
  PollKeys.pollVoted: 'Voted',
  PollKeys.pollnotVoted: 'Not Voted',

  //Invite
  InviteKeys.normalAccount: 'Normal Account',
  InviteKeys.verifiedAccount: 'Verified Account',
  InviteKeys.sendVerificationCode: 'Send Verification Code',

  // JoinUs
  JoinUsKeys.phoneNumberRegistered:
      'Phone number must be registered in the system.',
  JoinUsKeys.profilePhoto:
      'Profile photo must be different from the default logo.',
  JoinUsKeys.noPenalty: 'No penalties have been applied.',
  JoinUsKeys.noProvocation: 'Must not have provoked others.',

  JoinUsKeys.selectAnItem: 'Select an item',
  JoinUsKeys.selectAPosition: 'Select a position',
  JoinUsKeys.whyJoinTheTeam: 'Why do you want to join the team?',
  JoinUsKeys.whyChooseThisPermission: 'Why did you choose this permission?',
  JoinUsKeys.howManyDaysPerWeek: 'How many days per week can you dedicate?',

  //Event
  EventKeys.eventRules: 'Rules',
  EventKeys.eventcoordinator: 'Coordinator',
  EventKeys.eventdescriptions: 'Descriptions',
  EventKeys.eventParticipationEndedExplain:
      'The participation period for the event has ended. If you think this is a mistake, please contact the authorities.',
  EventKeys.alreadyJoinedEventWithDeadline:
      'You have already joined the event. To cancel, the deadline is 30 minutes before the event starts.',
  EventKeys.readAndAgreeRules:
      'I have read and understood the rules and accept them',
  //Settings
  SettingsKeys.translation: 'Translation',
  SettingsKeys.settings: 'Settings',
  SettingsKeys.accountSettings: 'Account Settings',

  SettingsKeys.lastFailedLogin: 'Failed Login',

  SettingsKeys.applicationAndMedia: 'Application and Media',
  SettingsKeys.devicePermissions: 'Device Permissions',
  SettingsKeys.downloadAndArchive: 'Download and Archive',
  SettingsKeys.dataSaver: 'Data Saver',
  SettingsKeys.languages: 'Languages',
  SettingsKeys.notifications: 'Notifications',
  SettingsKeys.blockedList: 'Blocked List',
  SettingsKeys.moreInformationAndSupport: 'More Information and Support',
  SettingsKeys.help: 'Help',
  SettingsKeys.accountStatus: 'Account Status',
  SettingsKeys.about: 'About',
  SettingsKeys.addAccount: 'Add Account',
  SettingsKeys.logOut: 'Log Out',
  SettingsKeys.version: 'Version',

  //Account Settings
  AccountKeys.passwordandsecurity: 'Password and Security',
  AccountKeys.personaldetails: 'Personal Details',
  AccountKeys.accountvalidate: 'Account Validate',
  AccountKeys.accountprivacy: 'Account Privacy',
  AccountKeys.deleteaccount: 'Delete Account',

  //Drawer
  DrawerKeys.drawerMeeting: 'Meeting',
  DrawerKeys.drawerNews: 'News',
  DrawerKeys.drawerMyGroups: 'My Groups',
  DrawerKeys.drawerMyGroupscreate: 'Create Group',
  DrawerKeys.drawerMySchools: 'My Schools',
  DrawerKeys.drawerMySchoolsjoin: 'Join School',

  DrawerKeys.drawerFood: 'Food',
  DrawerKeys.drawerGames: 'Games',
  DrawerKeys.drawerEvents: 'Events',
  DrawerKeys.drawerPolls: 'Polls',
  DrawerKeys.drawerInvite: 'Invite',
  DrawerKeys.drawerJoinUs: 'Join Us',
  DrawerKeys.drawerSettings: 'Settings',

  //Login
  LoginKeys.loginKeysUsernameoremail: 'Username / Email',
  LoginKeys.loginKeysPassword: 'Password',
  LoginKeys.loginKeysLogin: 'Login',
  LoginKeys.loginKeysForgotmypassword: 'Forgot my password',
  LoginKeys.loginKeysSignup: 'Sign Up',
  LoginKeys.loginKeysHaveyougotaccount: 'Have you got an account?',
  LoginKeys.loginKeysPrivacyPolicy: 'Privacy Policy',
  LoginKeys.loginKeysTermsAndConditions: 'Terms and Conditions/User Policy',
  LoginKeys.loginKeysacceptanceMessage:
      'By continuing, you accept the Terms and Conditions and Privacy Policy.',

  //Register
  RegisterKeys.registerKeysfirstname: 'First Name',
  RegisterKeys.registerKeyslastname: 'Last Name',
  RegisterKeys.registerKeysusername: 'Username',
  RegisterKeys.registerKeysemail: 'E-mail',
  RegisterKeys.registerKeyspassword: 'Password',
  RegisterKeys.registerKeysrepeatpassword: 'Re Password',
  RegisterKeys.registerKeysinvitecode: 'Invite Code',
  RegisterKeys.registerKeyssignup: 'Sign Up',
  RegisterKeys.registerKeyssignin: 'Sign In',
  RegisterKeys.registerKeysifyouhaveaccount: 'İf you have account',

  //ResetPassword
  ResetPasswordKeys.resetPasswordKeysusername: 'Username',
  ResetPasswordKeys.resetPasswordKeysemail: 'E-mail',
  ResetPasswordKeys.resetPasswordKeysifyourememberyourpassword:
      'If you remember your password',
  ResetPasswordKeys.resetPasswordKeyscontinue: 'Continue',
  ResetPasswordKeys.resetPasswordKeyssignin: 'Sign In',
  ResetPasswordKeys.resetPasswordKeyscode: 'Code',
  ResetPasswordKeys.resetPasswordKeyscreatepassword: 'Create Password',
  ResetPasswordKeys.resetPasswordKeysrepeatpassword: 'Repeat Password',
  ResetPasswordKeys.resetPasswordKeysrepeatsendcode: 'Repeat Send Code',
  ResetPasswordKeys.resetPasswordKeyssave: 'Save',

  // BlockedListKeys
  BlockedListKeys.noBlockedAccounts: 'No blocked accounts',
  BlockedListKeys.unblock: 'Unblock',

  // DevicePermissionKeys
  DevicePermissionKeys.deviceCamera: 'Camera',
  DevicePermissionKeys.deviceContact: 'Contact',
  DevicePermissionKeys.deviceLocation: 'Location',
  DevicePermissionKeys.deviceMicrpohone: 'Microphone',
  DevicePermissionKeys.deviceNotifications: 'Notifications',
  DevicePermissionKeys.deviceGranted: 'Granted',
  DevicePermissionKeys.deviceDenied: 'Denied',
  DevicePermissionKeys.devicePermanentlyDenied: 'Permanently Denied',

  //Data Saver
  DataSaverKeys.useLessCellularData: 'Use less cellular data',
  DataSaverKeys.useLessCellularDataExplain:
      "New page won't load until the end of the current page.",

  DataSaverKeys.uploadMediaInTheLowestQuality:
      'Upload media in the lowest quality',
  DataSaverKeys.uploadMediaInTheLowestQualityExplain:
      "Media is displayed in the lowest quality, which can be annoying.",

  DataSaverKeys.disableAutoplayVideos: 'Autoplay videos',
  DataSaverKeys.disableAutoplayVideosExplain: "Stop autoplaying videos.",

  // Notifications
  NotificationsKeys.commentLikes: "Comment Likes",
  NotificationsKeys.commentLikesExplain:
      "Notifies when your comments are liked",

  NotificationsKeys.postLikes: "Posts Likes",
  NotificationsKeys.postLikesExplain: "Notifies when your posts are liked",

  NotificationsKeys.comment: "Comments",
  NotificationsKeys.commentExplain: "Notifies when your posts receive comments",

  NotificationsKeys.commentReplies: "Comment Replies",
  NotificationsKeys.commentRepliesExplain:
      "Notifies when someone replies to your comment",

  NotificationsKeys.event: "Events",
  NotificationsKeys.eventExplain:
      "Notifies about all event-related announcements",

  NotificationsKeys.birthdays: "Birthdays",
  NotificationsKeys.birthdaysExplain:
      "Notifies you about your friends' birthdays",

  NotificationsKeys.messages: "Messages",
  NotificationsKeys.messagesExplain: "Notifies when you receive a new message",

  NotificationsKeys.calls: "Calls",
  NotificationsKeys.callsExplain: "Notifies when someone calls you",

  NotificationsKeys.mentions: "Mentions",
  NotificationsKeys.mentionsExplain:
      "Notifies when you are mentioned in any post or comment",

  // Help
  HelpKeys.reportIssue: "Report Issue",
  HelpKeys.reportIssueExplain: "Allows you to report any issues you encounter.",

  HelpKeys.supportRequests: "Support Requests",
  HelpKeys.supportRequestsExplain:
      "Notifies you when you receive a support request.",

  //AccountStatus

  AccountStatusKeys.accountStatusabout:
      "You can track any actions that violate the rules in your account or content here.",
  AccountStatusKeys.removedContent: "Removed Content",
  AccountStatusKeys.removedContentExplain:
      "Notifies you about content that has been removed from your account.",

  AccountStatusKeys.myRestrictions: "My Restrictions",
  AccountStatusKeys.myRestrictionsExplain:
      "Shows the restrictions applied to your account.",

  //About
  AboutKeys.aboutYourAccount: 'About Your Account',
  AboutKeys.privacyPolicy: 'Privacy Policy',
  AboutKeys.termsOfService: 'Terms of Service',
  AboutKeys.openSourceLibraries: 'Open Source Libraries',
};
