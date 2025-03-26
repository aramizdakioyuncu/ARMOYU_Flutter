import 'package:armoyu/app/translations/app_translation.dart';

Map<String, String> ar = {
  TranslateKeys.currentLanguage: 'العربية',

  //Common
  CommonKeys.search: "بحث",
  CommonKeys.empty: "فارغ",
  CommonKeys.join: "انضم",
  CommonKeys.leave: "غادر",
  CommonKeys.cancel: "إلغاء",
  CommonKeys.submit: "إرسال",
  CommonKeys.create: "إنشاء",
  CommonKeys.share: "مشاركة",
  CommonKeys.update: 'تحديث',
  CommonKeys.save: 'حفظ',
  CommonKeys.change: 'تغيير',
  CommonKeys.invite: 'دعوة',

  CommonKeys.accept: 'قبول',
  CommonKeys.decline: 'رفض',

  CommonKeys.online: 'متصل',
  CommonKeys.offline: 'غير متصل',

  CommonKeys.calling: 'يتصل',

  CommonKeys.second: 'ثانية',
  CommonKeys.minute: 'دقيقة',
  CommonKeys.hour: 'ساعة',

  CommonKeys.day: 'يوم',
  CommonKeys.month: 'شهر',
  CommonKeys.year: 'سنة',

  CommonKeys.everyone: 'الجميع',
  CommonKeys.friends: 'الأصدقاء',

  QuestionKeys.areyousure: 'هل أنت متأكد؟',
  QuestionKeys.areyousuredetail: 'هل أنت متأكد من هذه العملية؟',
  QuestionKeys.areyousuredetaildescription:
      'لن يؤدي هذا الإجراء إلى حذف حسابك مباشرةً، بل سيتم وضعه في قائمة الانتظار. إذا لم تقم بتسجيل الدخول إلى حسابك خلال 60 يومًا، فسيتم حذفه تلقائيًا بواسطة النظام.',

  AnswerKeys.yourRequestReceived: 'تم استلام طلبك.',

  //Social
  SocialKeys.socialStory: 'قصتك',
  SocialKeys.socialandnumberpersonLiked: 'و #NUMBER# شخص أعجبهم',
  SocialKeys.socialLiked: 'اعجبني',
  SocialKeys.socialViewAllComments: 'عرض جميع التعليقات',

  SocialKeys.socialComments: 'التعليقات',
  SocialKeys.socialWriteFirstComment: 'اكتب أول تعليق',
  SocialKeys.socialWriteComment: 'اكتب تعليقًا',

  SocialKeys.socialLikers: 'المعجبون',

  SocialKeys.socialAddFavorite: 'إضافة إلى المفضلة',
  SocialKeys.socialReport: 'إبلاغ',
  SocialKeys.socialBlock: 'حظر المستخدم',
  SocialKeys.socialedit: 'تعديل المنشور',
  SocialKeys.socialdelete: 'حذف المنشور',

  SocialKeys.socialShare: 'مشاركة المنشور',
  SocialKeys.socialwritesomething: 'اكتب شيئًا',

  //Notification
  NotificationKeys.friendRequests: 'طلب صداقة',
  NotificationKeys.reviewFriendRequests: 'مراجعة طلبات الصداقة',
  NotificationKeys.groupRequests: 'طلبات المجموعة',
  NotificationKeys.reviewGroupRequests: 'مراجعة طلبات المجموعة',

  //Profile

  ProfileKeys.profilerefresh: 'تحديث الملف الشخصي',
  ProfileKeys.profileEdit: 'تعديل الملف الشخصي',
  ProfileKeys.profilecopylink: 'نسخ رابط الملف الشخصي',
  ProfileKeys.profileblock: 'حظر المستخدم',
  ProfileKeys.profilereport: 'إبلاغ عن الملف الشخصي',
  ProfileKeys.profileremovefriend: 'إزالة من الأصدقاء',
  ProfileKeys.profilepoke: 'نخزة',

  ProfileKeys.profilePost: 'منشور',
  ProfileKeys.profilefriend: 'صديق',
  ProfileKeys.profileaward: 'جائزة',

  ProfileKeys.profilePosts: 'المنشورات',
  ProfileKeys.profileMedia: 'الوسائط',
  ProfileKeys.profileMentions: 'الإشارات',

  ProfileKeys.profilefirstname: 'الاسم الأول',
  ProfileKeys.profilelastname: 'الاسم الأخير',
  ProfileKeys.profileaboutme: 'عني',
  ProfileKeys.profileemail: 'البريد الإلكتروني',
  ProfileKeys.profilelocation: 'الموقع',
  ProfileKeys.profilebirthdate: 'تاريخ الميلاد',
  ProfileKeys.profilephonenumber: 'رقم الهاتف',
  ProfileKeys.profilecheckpassword: 'تحقق من كلمة المرور',

  ProfileKeys.profileselectcountry: 'اختر البلد',
  ProfileKeys.profileselectcity: 'اختر المدينة',

  //Chat
  ChatKeys.chat: 'المحادثات',
  ChatKeys.chatyournote: 'ملاحظتك',
  ChatKeys.chatshareasong: 'مشاركة أغنية',
  ChatKeys.chatnewchat: 'دردشة جديدة',
  ChatKeys.chatwritemessage: 'اكتب رسالة',

  ChatKeys.chatTargetAudience: 'الجمهور المستهدف',

  //Group
  GroupKeys.createGroup: 'إنشاء مجموعة',
  GroupKeys.groupName: 'اسم المجموعة',
  GroupKeys.groupShortname: 'الاسم المختصر للمجموعة',

  GroupKeys.groupkickuser: 'طرد المستخدم من المجموعة',
  GroupKeys.groupInviteuser: 'دعوة المستخدم إلى المجموعة',
  GroupKeys.groupInviteNumberuserSelected: 'عدد المستخدمين المدعوين تم اختياره',
  GroupKeys.groupMember: 'عضو المجموعة',
  GroupKeys.groupLogo: 'شعار المجموعة',
  GroupKeys.groupbanner: 'لافتة المجموعة',
  GroupKeys.groupdescription: 'وصف المجموعة',
  GroupKeys.groupwebsite: 'موقع المجموعة',
  GroupKeys.groupisJoinable: 'هل يمكن الانضمام إلى المجموعة',

  //School
  SchoolKeys.joinSchool: 'انضم إلى المدرسة',
  SchoolKeys.schoolPassword: 'كلمة المرور',
  SchoolKeys.schoolJoin: 'انضم',

  //Food
  FoodKeys.orderExplain: 'يرجى المسح عند الخروج لتقديم طلبك.',
  FoodKeys.foodProduct: 'المنتج',
  FoodKeys.foodPrice: 'السعر',

  //Poll

  PollKeys.createPoll: 'إنشاء استطلاع',
  PollKeys.pollquestion: 'سؤال الاستطلاع',
  PollKeys.pollanswers: 'إجابات الاستطلاع',
  PollKeys.pollOption: 'الخيار',
  PollKeys.pollAddOption: 'إضافة خيار',

  PollKeys.selectHour: 'اختر الساعة',
  PollKeys.selectDate: 'اختر التاريخ',

  PollKeys.selectPollMultipleChoice: 'خيارات متعددة',
  PollKeys.selectPollCheckboxes: 'مربعات اختيار',
  PollKeys.selectPollShortAnswer: 'إجابة قصيرة',

  PollKeys.pollExpired: 'منتهي',
  PollKeys.pollVoted: 'تم التصويت',
  PollKeys.pollnotVoted: 'لم يتم التصويت',

  //Invite
  InviteKeys.normalAccount: 'حساب عادي',
  InviteKeys.verifiedAccount: 'حساب موثق',
  InviteKeys.sendVerificationCode: 'إرسال رمز التحقق',

  // JoinUs
  JoinUsKeys.phoneNumberRegistered: 'يجب تسجيل رقم الهاتف في النظام.',
  JoinUsKeys.profilePhoto:
      'يجب أن تكون صورة الملف الشخصي مختلفة عن الشعار الافتراضي.',
  JoinUsKeys.noPenalty: 'لم يتم تطبيق أي عقوبات.',
  JoinUsKeys.noProvocation: 'يجب ألا يكون قد استفز الآخرين.',

  JoinUsKeys.selectAnItem: 'اختر عنصرًا',
  JoinUsKeys.selectAPosition: 'اختر منصبًا',
  JoinUsKeys.whyJoinTheTeam: 'لماذا تريد الانضمام إلى الفريق؟',
  JoinUsKeys.whyChooseThisPermission: 'لماذا اخترت هذا الإذن؟',
  JoinUsKeys.howManyDaysPerWeek: 'كم عدد الأيام في الأسبوع التي يمكنك تخصيصها؟',

  //Event
  EventKeys.eventRules: 'القواعد',
  EventKeys.eventcoordinator: 'المنسق',
  EventKeys.eventdescriptions: 'الأوصاف',
  EventKeys.eventParticipationEndedExplain:
      'انتهت فترة المشاركة في الحدث. إذا كنت تعتقد أن هناك خطأً، يرجى الاتصال بالسلطات.',
  EventKeys.alreadyJoinedEventWithDeadline:
      'لقد انضممت بالفعل إلى الحدث. للإلغاء، الموعد النهائي هو 30 دقيقة قبل بدء الحدث.',
  EventKeys.readAndAgreeRules: 'لقد قرأت وفهمت القواعد وأوافق عليها',

  //Settings
  SettingsKeys.translation: 'الترجمة',
  SettingsKeys.settings: 'الإعدادات',
  SettingsKeys.accountSettings: 'إعدادات الحساب',
  SettingsKeys.lastFailedLogin: 'فشل تسجيل الدخول',

  SettingsKeys.applicationAndMedia: 'التطبيق والإعلام',
  SettingsKeys.devicePermissions: 'أذونات الجهاز',
  SettingsKeys.downloadAndArchive: 'تحميل وأرشفة',
  SettingsKeys.dataSaver: 'توفير البيانات',
  SettingsKeys.languages: 'اللغات',
  SettingsKeys.notifications: 'الإشعارات',
  SettingsKeys.blockedList: 'القائمة المحظورة',
  SettingsKeys.moreInformationAndSupport: 'مزيد من المعلومات والدعم',
  SettingsKeys.help: 'المساعدة',
  SettingsKeys.accountStatus: 'حالة الحساب',
  SettingsKeys.about: 'حول',
  SettingsKeys.addAccount: 'إضافة حساب',
  SettingsKeys.logOut: 'تسجيل الخروج',
  SettingsKeys.version: 'النسخة',

  //Account Settings
  AccountKeys.passwordandsecurity: 'كلمة المرور والأمان',
  AccountKeys.personaldetails: 'التفاصيل الشخصية',
  AccountKeys.accountvalidate: 'التحقق من الحساب',
  AccountKeys.accountprivacy: 'خصوصية الحساب',
  AccountKeys.deleteaccount: 'حذف الحساب',

  //Drawer
  DrawerKeys.drawerMeeting: 'الاجتماع',
  DrawerKeys.drawerNews: 'الأخبار',
  DrawerKeys.drawerMyGroups: 'مجموعاتي',
  DrawerKeys.drawerMyGroupscreate: 'إنشاء مجموعة',
  DrawerKeys.drawerMySchools: 'مدارسي',
  DrawerKeys.drawerMySchoolsjoin: 'انضم إلى المدرسة',

  DrawerKeys.drawerFood: 'الطعام',
  DrawerKeys.drawerGames: 'الألعاب',
  DrawerKeys.drawerEvents: 'الأحداث',
  DrawerKeys.drawerPolls: 'الاستطلاعات',
  DrawerKeys.drawerInvite: 'دعوة',
  DrawerKeys.drawerJoinUs: 'انضم إلينا',
  DrawerKeys.drawerSettings: 'الإعدادات',

  //Login
  LoginKeys.loginKeysUsernameoremail: 'اسم المستخدم / البريد الإلكتروني',
  LoginKeys.loginKeysPassword: 'كلمة المرور',
  LoginKeys.loginKeysLogin: 'تسجيل الدخول',
  LoginKeys.loginKeysForgotmypassword: 'نسيت كلمة المرور',
  LoginKeys.loginKeysSignup: 'إنشاء حساب',
  LoginKeys.loginKeysHaveyougotaccount: 'هل لديك حساب؟',
  LoginKeys.loginKeysPrivacyPolicy: 'سياسة الخصوصية',
  LoginKeys.loginKeysTermsAndConditions: 'الشروط والأحكام/سياسة المستخدم',
  LoginKeys.loginKeysacceptanceMessage:
      'بالمتابعة، فإنك توافق على الشروط والأحكام وسياسة الخصوصية.',

  //Register
  RegisterKeys.registerKeysfirstname: 'الاسم الأول',
  RegisterKeys.registerKeyslastname: 'الاسم الأخير',
  RegisterKeys.registerKeysusername: 'اسم المستخدم',
  RegisterKeys.registerKeysemail: 'البريد الإلكتروني',
  RegisterKeys.registerKeyspassword: 'كلمة المرور',
  RegisterKeys.registerKeysrepeatpassword: 'أعد إدخال كلمة المرور',
  RegisterKeys.registerKeysinvitecode: 'رمز الدعوة',
  RegisterKeys.registerKeyssignup: 'إنشاء حساب',
  RegisterKeys.registerKeyssignin: 'تسجيل الدخول',
  RegisterKeys.registerKeysifyouhaveaccount: 'إذا كان لديك حساب',

  //ResetPassword
  ResetPasswordKeys.resetPasswordKeysusername: 'اسم المستخدم',
  ResetPasswordKeys.resetPasswordKeysemail: 'البريد الإلكتروني',
  ResetPasswordKeys.resetPasswordKeysifyourememberyourpassword:
      'إذا كنت تتذكر كلمة المرور الخاصة بك',
  ResetPasswordKeys.resetPasswordKeyscontinue: 'متابعة',
  ResetPasswordKeys.resetPasswordKeyssignin: 'تسجيل الدخول',
  ResetPasswordKeys.resetPasswordKeyscode: 'الرمز',
  ResetPasswordKeys.resetPasswordKeyscreatepassword: 'إنشاء كلمة مرور',
  ResetPasswordKeys.resetPasswordKeysrepeatpassword: 'أعد إدخال كلمة المرور',
  ResetPasswordKeys.resetPasswordKeysrepeatsendcode: 'إعادة إرسال الرمز',
  ResetPasswordKeys.resetPasswordKeyssave: 'حفظ',

  // BlockedListKeys
  BlockedListKeys.noBlockedAccounts: 'لا توجد حسابات محظورة',
  BlockedListKeys.unblock: 'إلغاء الحظر',

  // DevicePermissionKeys
  DevicePermissionKeys.deviceCamera: 'الكاميرا',
  DevicePermissionKeys.deviceContact: 'جهات الاتصال',
  DevicePermissionKeys.deviceLocation: 'الموقع',
  DevicePermissionKeys.deviceMicrpohone: 'الميكروفون',
  DevicePermissionKeys.deviceNotifications: 'الإشعارات',
  DevicePermissionKeys.deviceGranted: 'مسموح',
  DevicePermissionKeys.deviceDenied: 'مرفوض',
  DevicePermissionKeys.devicePermanentlyDenied: 'مرفوض نهائياً',

  //Data Saver
  DataSaverKeys.useLessCellularData: 'استخدام بيانات خلوية أقل',
  DataSaverKeys.useLessCellularDataExplain:
      'لن يتم تحميل الصفحة الجديدة حتى نهاية الصفحة الحالية.',

  DataSaverKeys.uploadMediaInTheLowestQuality: 'تحميل الوسائط بأقل جودة',
  DataSaverKeys.uploadMediaInTheLowestQualityExplain:
      'يتم عرض الوسائط بأقل جودة، قد يكون هذا مزعجًا.',

  DataSaverKeys.disableAutoplayVideos: 'تشغيل الفيديو تلقائيًا',
  DataSaverKeys.disableAutoplayVideosExplain:
      'إيقاف التشغيل التلقائي للفيديوهات.',

  // Notifications
  NotificationsKeys.commentLikes: "الإعجابات على التعليقات",
  NotificationsKeys.commentLikesExplain: "يُخطرك عند الإعجاب بتعليقاتك",

  NotificationsKeys.postLikes: "الإعجابات على المنشورات",
  NotificationsKeys.postLikesExplain: "يُخطرك عند الإعجاب بمنشوراتك",

  NotificationsKeys.comment: "التعليقات",
  NotificationsKeys.commentExplain: "يُخطرك عند تلقي تعليقات على منشوراتك",

  NotificationsKeys.commentReplies: "الردود على التعليقات",
  NotificationsKeys.commentRepliesExplain: "يُخطرك عندما يرد شخص ما على تعليقك",

  NotificationsKeys.event: "الأحداث",
  NotificationsKeys.eventExplain: "يُخطرك بجميع الإعلانات المتعلقة بالأحداث",

  NotificationsKeys.birthdays: "أعياد الميلاد",
  NotificationsKeys.birthdaysExplain: "يُخطرك بأعياد ميلاد أصدقائك",

  NotificationsKeys.messages: "الرسائل",
  NotificationsKeys.messagesExplain: "يُخطرك عند تلقي رسالة جديدة",

  NotificationsKeys.calls: "المكالمات",
  NotificationsKeys.callsExplain: "يُخطرك عندما يتصل بك شخص ما",

  NotificationsKeys.mentions: "الإشارات",
  NotificationsKeys.mentionsExplain: "يُخطرك عند ذكرك في أي منشور أو تعليق",

  // Help
  HelpKeys.reportIssue: "الإبلاغ عن مشكلة",
  HelpKeys.reportIssueExplain: "يتيح لك الإبلاغ عن أي مشكلات تواجهها.",

  HelpKeys.supportRequests: "طلبات الدعم",
  HelpKeys.supportRequestsExplain: "يُخطرك عند تلقي طلب دعم.",

  //AccountStatus

  AccountStatusKeys.accountStatusabout:
      "يمكنك تتبع أي إجراءات تنتهك القواعد في حسابك أو محتواك هنا.",
  AccountStatusKeys.removedContent: "المحتوى المحذوف",
  AccountStatusKeys.removedContentExplain:
      "يُخطرك بالمحتوى الذي تم حذفه من حسابك.",

  AccountStatusKeys.myRestrictions: "قيودي",
  AccountStatusKeys.myRestrictionsExplain: "يعرض القيود المطبقة على حسابك.",

  //About
  AboutKeys.aboutYourAccount: 'عن حسابك',
  AboutKeys.privacyPolicy: 'سياسة الخصوصية',
  AboutKeys.termsOfService: 'شروط الخدمة',
  AboutKeys.openSourceLibraries: 'المكتبات مفتوحة المصدر',
};
