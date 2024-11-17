import 'package:ARMOYU/app/translations/app_translation.dart';

Map<String, String> ru = {
  TranslateKeys.currentLanguage: 'Русский',

  //Common
  CommonKeys.search: "Поиск",
  CommonKeys.empty: "Пусто",
  CommonKeys.join: "Присоединиться",
  CommonKeys.leave: "Покинуть",
  CommonKeys.cancel: "Отменить",
  CommonKeys.submit: "Отправить",
  CommonKeys.create: "Создать",
  CommonKeys.share: "Поделиться",
  CommonKeys.update: 'Обновить',
  CommonKeys.save: 'сохранить',
  CommonKeys.change: 'изменить',
  CommonKeys.invite: 'Пригласить',

  CommonKeys.accept: 'Принять',
  CommonKeys.decline: 'Отклонить',

  CommonKeys.online: 'Онлайн',
  CommonKeys.offline: 'Офлайн',

  CommonKeys.calling: 'Звонок',

  CommonKeys.second: 'Секунда',
  CommonKeys.minute: 'Минута',
  CommonKeys.hour: 'Час',

  CommonKeys.day: 'День',
  CommonKeys.month: 'Месяц',
  CommonKeys.year: 'Год',

  CommonKeys.everyone: 'Все',
  CommonKeys.friends: 'Друзья',

  QuestionKeys.areyousure: 'Вы уверены?',
  QuestionKeys.areyousuredetail:
      'Вы уверены, что хотите выполнить этот процесс?',
  QuestionKeys.areyousuredetaildescription:
      'Это действие не удаляет ваш аккаунт сразу, а ставит его в очередь. Если вы не войдете в свой аккаунт в течение 60 дней, он будет автоматически удален системой.',

  AnswerKeys.yourRequestReceived: 'Ваш запрос получен.',

  //Social
  SocialKeys.socialStory: 'Ваша история',
  SocialKeys.socialandnumberpersonLiked: 'и #NUMBER# человек понравилось',
  SocialKeys.socialLiked: 'понравилось',
  SocialKeys.socialViewAllComments: 'Посмотреть все комментарии',

  SocialKeys.socialComments: 'Комментарии',
  SocialKeys.socialWriteFirstComment: 'Написать первый комментарий',
  SocialKeys.socialWriteComment: 'Написать комментарий',

  SocialKeys.socialLikers: 'Лайкнувшие',

  SocialKeys.socialAddFavorite: 'Добавить в избранное',
  SocialKeys.socialReport: 'Пожаловаться',
  SocialKeys.socialBlock: 'Заблокировать пользователя',
  SocialKeys.socialedit: 'Редактировать пост',
  SocialKeys.socialdelete: 'Удалить пост',

  SocialKeys.socialShare: 'Поделиться постом',
  SocialKeys.socialwritesomething: 'Напишите что-нибудь',

  //Notification
  NotificationKeys.friendRequests: 'Запрос в друзья',
  NotificationKeys.reviewFriendRequests: 'Просмотреть запросы в друзья',
  NotificationKeys.groupRequests: 'Запросы в группы',
  NotificationKeys.reviewGroupRequests: 'Просмотреть запросы в группы',

  //Profile

  ProfileKeys.profilerefresh: 'Обновить профиль',
  ProfileKeys.profileEdit: 'Редактировать профиль',
  ProfileKeys.profilecopylink: 'Скопировать ссылку на профиль',
  ProfileKeys.profileblock: 'Заблокировать пользователя',
  ProfileKeys.profilereport: 'Пожаловаться на профиль',
  ProfileKeys.profileremovefriend: 'Удалить из друзей',
  ProfileKeys.profilepoke: 'Покачать',

  ProfileKeys.profilePost: 'Пост',
  ProfileKeys.profilefriend: 'Друг',
  ProfileKeys.profileaward: 'Награда',

  ProfileKeys.profilePosts: 'Посты',
  ProfileKeys.profileMedia: 'Медиа',
  ProfileKeys.profileMentions: 'Упоминания',

  ProfileKeys.profilefirstname: 'Имя',
  ProfileKeys.profilelastname: 'Фамилия',
  ProfileKeys.profileaboutme: 'О себе',
  ProfileKeys.profileemail: 'Электронная почта',
  ProfileKeys.profilelocation: 'Местоположение',
  ProfileKeys.profilebirthdate: 'Дата рождения',
  ProfileKeys.profilephonenumber: 'Номер телефона',
  ProfileKeys.profilecheckpassword: 'Проверить пароль',

  ProfileKeys.profileselectcountry: 'Выбрать страну',
  ProfileKeys.profileselectcity: 'Выбрать город',

  //Chat
  ChatKeys.chat: 'Чаты',
  ChatKeys.chatyournote: 'Ваша заметка',
  ChatKeys.chatshareasong: 'Поделиться песней',
  ChatKeys.chatnewchat: 'Новый чат',
  ChatKeys.chatwritemessage: 'Написать сообщение',

  ChatKeys.chatTargetAudience: 'Целевая аудитория',

  //Group
  GroupKeys.createGroup: 'Создать группу',
  GroupKeys.groupName: 'Название группы',
  GroupKeys.groupShortname: 'Краткое название группы',

  GroupKeys.groupkickuser: 'Удалить пользователя из группы',
  GroupKeys.groupInviteuser: 'Пригласить пользователя в группу',
  GroupKeys.groupInviteNumberuserSelected:
      'Выбранное количество приглашённых пользователей',
  GroupKeys.groupMember: 'Член группы',
  GroupKeys.groupLogo: 'Логотип группы',
  GroupKeys.groupbanner: 'Баннер группы',
  GroupKeys.groupdescription: 'Описание группы',
  GroupKeys.groupwebsite: 'Веб-сайт группы',
  GroupKeys.groupisJoinable: 'Группа доступна для присоединения',

  //School
  SchoolKeys.joinSchool: 'Присоединиться к школе',
  SchoolKeys.schoolPassword: 'Пароль',
  SchoolKeys.schoolJoin: 'Присоединиться',

  //Food
  FoodKeys.orderExplain:
      'Пожалуйста, отсканируйте на кассе, чтобы сделать заказ.',
  FoodKeys.foodProduct: 'Продукт',
  FoodKeys.foodPrice: 'Цена',

  //Poll

  PollKeys.createPoll: 'Создать опрос',
  PollKeys.pollquestion: 'Вопрос опроса',
  PollKeys.pollanswers: 'Ответы на опрос',
  PollKeys.pollOption: 'Опция',
  PollKeys.pollAddOption: 'Добавить опцию',

  PollKeys.selectHour: 'Выберите час',
  PollKeys.selectDate: 'Выберите дату',

  PollKeys.selectPollMultipleChoice: 'Множественный выбор',
  PollKeys.selectPollCheckboxes: 'Чекбоксы',
  PollKeys.selectPollShortAnswer: 'Краткий ответ',

  PollKeys.pollExpired: 'Истекший срок',
  PollKeys.pollVoted: 'Проголосовано',
  PollKeys.pollnotVoted: 'Не проголосовано',

  //Invite
  InviteKeys.normalAccount: 'Обычный аккаунт',
  InviteKeys.verifiedAccount: 'Подтвержденный аккаунт',
  InviteKeys.sendVerificationCode: 'Отправить код подтверждения',

  // JoinUs
  JoinUsKeys.phoneNumberRegistered:
      'Номер телефона должен быть зарегистрирован в системе.',
  JoinUsKeys.profilePhoto:
      'Фото профиля должно отличаться от стандартного логотипа.',
  JoinUsKeys.noPenalty: 'Штрафы не были применены.',
  JoinUsKeys.noProvocation: 'Не должно быть провокаций в отношении других.',

  JoinUsKeys.selectAnItem: 'Выберите элемент',
  JoinUsKeys.selectAPosition: 'Выберите должность',
  JoinUsKeys.whyJoinTheTeam: 'Почему вы хотите присоединиться к команде?',
  JoinUsKeys.whyChooseThisPermission: 'Почему вы выбрали этот доступ?',
  JoinUsKeys.howManyDaysPerWeek: 'Сколько дней в неделю вы можете уделять?',

  //Event
  EventKeys.eventRules: 'Правила',
  EventKeys.eventcoordinator: 'Координатор',
  EventKeys.eventdescriptions: 'Описание',
  EventKeys.eventParticipationEndedExplain:
      'Период участия в событии завершен. Если вы считаете, что это ошибка, пожалуйста, свяжитесь с организаторами.',
  EventKeys.alreadyJoinedEventWithDeadline:
      'Вы уже присоединились к событию. Для отмены, крайний срок — за 30 минут до начала события.',
  EventKeys.readAndAgreeRules: 'Я прочитал(а) и понял(а) правила и принимаю их',
  //Settings
  SettingsKeys.translation: 'Перевод',
  SettingsKeys.settings: 'Настройки',
  SettingsKeys.accountSettings: 'Настройки аккаунта',

  SettingsKeys.lastFailedLogin: 'Неудачная попытка входа',

  SettingsKeys.applicationAndMedia: 'Приложение и медиа',
  SettingsKeys.devicePermissions: 'Разрешения устройства',
  SettingsKeys.downloadAndArchive: 'Загрузка и архивирование',
  SettingsKeys.dataSaver: 'Экономия данных',
  SettingsKeys.languages: 'Языки',
  SettingsKeys.notifications: 'Уведомления',
  SettingsKeys.blockedList: 'Список заблокированных',
  SettingsKeys.moreInformationAndSupport:
      'Дополнительная информация и поддержка',
  SettingsKeys.help: 'Помощь',
  SettingsKeys.accountStatus: 'Статус аккаунта',
  SettingsKeys.about: 'О приложении',
  SettingsKeys.addAccount: 'Добавить аккаунт',
  SettingsKeys.logOut: 'Выйти',
  SettingsKeys.version: 'Версия',

  //Account Settings
  AccountKeys.passwordandsecurity: 'Пароль и безопасность',
  AccountKeys.personaldetails: 'Личные данные',
  AccountKeys.accountvalidate: 'Проверка аккаунта',
  AccountKeys.accountprivacy: 'Конфиденциальность аккаунта',
  AccountKeys.deleteaccount: 'Удалить аккаунт',

  //Drawer
  DrawerKeys.drawerMeeting: 'Встреча',
  DrawerKeys.drawerNews: 'Новости',
  DrawerKeys.drawerMyGroups: 'Мои группы',
  DrawerKeys.drawerMyGroupscreate: 'Создать группу',
  DrawerKeys.drawerMySchools: 'Мои школы',
  DrawerKeys.drawerMySchoolsjoin: 'Присоединиться к школе',

  DrawerKeys.drawerFood: 'Еда',
  DrawerKeys.drawerGames: 'Игры',
  DrawerKeys.drawerEvents: 'События',
  DrawerKeys.drawerPolls: 'Опросы',
  DrawerKeys.drawerInvite: 'Пригласить',
  DrawerKeys.drawerJoinUs: 'Присоединиться к нам',
  DrawerKeys.drawerSettings: 'Настройки',

  //Login
  LoginKeys.loginKeysUsernameoremail: 'Имя пользователя / Электронная почта',
  LoginKeys.loginKeysPassword: 'Пароль',
  LoginKeys.loginKeysLogin: 'Войти',
  LoginKeys.loginKeysForgotmypassword: 'Забыли пароль?',
  LoginKeys.loginKeysSignup: 'Зарегистрироваться',
  LoginKeys.loginKeysHaveyougotaccount: 'У вас есть аккаунт?',
  LoginKeys.loginKeysPrivacyPolicy: 'Политика конфиденциальности',
  LoginKeys.loginKeysTermsAndConditions:
      'Условия и положения / Пользовательская политика',
  LoginKeys.loginKeysacceptanceMessage:
      'Продолжая, вы принимаете Условия и положения и Политику конфиденциальности.',

  //Register
  RegisterKeys.registerKeysfirstname: 'Имя',
  RegisterKeys.registerKeyslastname: 'Фамилия',
  RegisterKeys.registerKeysusername: 'Имя пользователя',
  RegisterKeys.registerKeysemail: 'Электронная почта',
  RegisterKeys.registerKeyspassword: 'Пароль',
  RegisterKeys.registerKeysrepeatpassword: 'Повторите пароль',
  RegisterKeys.registerKeysinvitecode: 'Код приглашения',
  RegisterKeys.registerKeyssignup: 'Зарегистрироваться',
  RegisterKeys.registerKeyssignin: 'Войти',
  RegisterKeys.registerKeysifyouhaveaccount: 'Если у вас уже есть аккаунт',

  //ResetPassword
  ResetPasswordKeys.resetPasswordKeysusername: 'Имя пользователя',
  ResetPasswordKeys.resetPasswordKeysemail: 'Электронная почта',
  ResetPasswordKeys.resetPasswordKeysifyourememberyourpassword:
      'Если вы помните свой пароль',
  ResetPasswordKeys.resetPasswordKeyscontinue: 'Продолжить',
  ResetPasswordKeys.resetPasswordKeyssignin: 'Войти',
  ResetPasswordKeys.resetPasswordKeyscode: 'Код',
  ResetPasswordKeys.resetPasswordKeyscreatepassword: 'Создать пароль',
  ResetPasswordKeys.resetPasswordKeysrepeatpassword: 'Повторите пароль',
  ResetPasswordKeys.resetPasswordKeysrepeatsendcode: 'Повторно отправить код',
  ResetPasswordKeys.resetPasswordKeyssave: 'Сохранить',

  // BlockedListKeys
  BlockedListKeys.noBlockedAccounts: 'Нет заблокированных аккаунтов',
  BlockedListKeys.unblock: 'Разблокировать',

  // DevicePermissionKeys
  DevicePermissionKeys.deviceCamera: 'Камера',
  DevicePermissionKeys.deviceContact: 'Контакты',
  DevicePermissionKeys.deviceLocation: 'Местоположение',
  DevicePermissionKeys.deviceMicrpohone: 'Микрофон',
  DevicePermissionKeys.deviceNotifications: 'Уведомления',
  DevicePermissionKeys.deviceGranted: 'Предоставлено',
  DevicePermissionKeys.deviceDenied: 'Отказано',
  DevicePermissionKeys.devicePermanentlyDenied: 'Окончательно отказано',

  //Data Saver
  DataSaverKeys.useLessCellularData: 'Использовать меньше мобильных данных',
  DataSaverKeys.useLessCellularDataExplain:
      "Новая страница не загрузится, пока не закончится текущая.",

  DataSaverKeys.uploadMediaInTheLowestQuality:
      'Загружать медиа в низком качестве',
  DataSaverKeys.uploadMediaInTheLowestQualityExplain:
      "Медиа отображается в самом низком качестве, что может быть раздражающим.",

  DataSaverKeys.disableAutoplayVideos: 'Отключить автозапуск видео',
  DataSaverKeys.disableAutoplayVideosExplain: "Остановить автозапуск видео.",

  // Notifications
  NotificationsKeys.commentLikes: "Лайки на комментарии",
  NotificationsKeys.commentLikesExplain:
      "Уведомляет, когда ваши комментарии получают лайки",

  NotificationsKeys.postLikes: "Лайки на посты",
  NotificationsKeys.postLikesExplain:
      "Уведомляет, когда ваши посты получают лайки",

  NotificationsKeys.comment: "Комментарии",
  NotificationsKeys.commentExplain:
      "Уведомляет, когда ваши посты получают комментарии",

  NotificationsKeys.commentReplies: "Ответы на комментарии",
  NotificationsKeys.commentRepliesExplain:
      "Уведомляет, когда кто-то отвечает на ваш комментарий",

  NotificationsKeys.event: "События",
  NotificationsKeys.eventExplain:
      "Уведомляет о всех объявлениях, связанных с событиями",

  NotificationsKeys.birthdays: "Дни рождения",
  NotificationsKeys.birthdaysExplain: "Уведомляет о днях рождения ваших друзей",

  NotificationsKeys.messages: "Сообщения",
  NotificationsKeys.messagesExplain:
      "Уведомляет, когда вы получаете новое сообщение",

  NotificationsKeys.calls: "Звонки",
  NotificationsKeys.callsExplain: "Уведомляет, когда кто-то звонит вам",

  NotificationsKeys.mentions: "Упоминания",
  NotificationsKeys.mentionsExplain:
      "Уведомляет, когда вас упоминают в любом посте или комментарии",

  // Help
  HelpKeys.reportIssue: "Сообщить о проблеме",
  HelpKeys.reportIssueExplain:
      "Позволяет сообщить о любых возникших проблемах.",

  HelpKeys.supportRequests: "Запросы на поддержку",
  HelpKeys.supportRequestsExplain:
      "Уведомляет, когда вы получаете запрос на поддержку.",

  //AccountStatus

  AccountStatusKeys.accountStatusabout:
      "Здесь вы можете отслеживать любые действия, нарушающие правила на вашем аккаунте или контенте.",
  AccountStatusKeys.removedContent: "Удаленный контент",
  AccountStatusKeys.removedContentExplain:
      "Уведомляет вас о контенте, который был удален с вашего аккаунта.",

  AccountStatusKeys.myRestrictions: "Мои ограничения",
  AccountStatusKeys.myRestrictionsExplain:
      "Показывает ограничения, примененные к вашему аккаунту.",

  //About
  AboutKeys.aboutYourAccount: 'О вашем аккаунте',
  AboutKeys.privacyPolicy: 'Политика конфиденциальности',
  AboutKeys.termsOfService: 'Условия обслуживания',
  AboutKeys.openSourceLibraries: 'Библиотеки с открытым исходным кодом',
};
