import 'package:ARMOYU/app/translations/app_translation.dart';

Map<String, String> de = {
  TranslateKeys.currentLanguage: 'Deutsch',

  //Common
  CommonKeys.search: "Suche",
  CommonKeys.empty: "Leer",
  CommonKeys.join: "Beitreten",
  CommonKeys.leave: "Verlassen",
  CommonKeys.cancel: "Abbrechen",
  CommonKeys.submit: "Absenden",
  CommonKeys.create: "Erstellen",
  CommonKeys.share: "Teilen",
  CommonKeys.update: 'Aktualisieren',
  CommonKeys.save: "speichern",
  CommonKeys.change: "ändern",
  CommonKeys.invite: 'Einladen',

  CommonKeys.accept: 'Akzeptieren',
  CommonKeys.decline: 'Ablehnen',

  CommonKeys.online: 'Online',
  CommonKeys.offline: 'Offline',

  CommonKeys.calling: 'Anrufen',

  CommonKeys.second: 'Sekunde',
  CommonKeys.minute: 'Minute',
  CommonKeys.hour: 'Stunde',

  CommonKeys.day: 'Tag',
  CommonKeys.month: 'Monat',
  CommonKeys.year: 'Jahr',

  CommonKeys.everyone: 'Jeder',
  CommonKeys.friends: 'Freunde',

  //Social
  SocialKeys.socialStory: 'Deine Geschichte',
  SocialKeys.socialandnumberpersonLiked: 'und #NUMBER# Person(en) mochte(n)',
  SocialKeys.socialLiked: 'mochte',
  SocialKeys.socialViewAllComments: 'Alle Kommentare anzeigen',

  SocialKeys.socialComments: 'Kommentare',
  SocialKeys.socialWriteFirstComment: 'Schreibe den ersten Kommentar',
  SocialKeys.socialWriteComment: 'Kommentar schreiben',

  SocialKeys.socialLikers: 'Liker',

  SocialKeys.socialAddFavorite: 'Zu den Favoriten hinzufügen',
  SocialKeys.socialReport: 'Melden',
  SocialKeys.socialBlock: 'Benutzer blockieren',
  SocialKeys.socialedit: 'Beitrag bearbeiten',
  SocialKeys.socialdelete: 'Beitrag löschen',

  SocialKeys.socialShare: 'Beitrag teilen',
  SocialKeys.socialwritesomething: 'Schreibe etwas',

  //Notification
  NotificationKeys.friendRequests: 'Freundschaftsanfrage',
  NotificationKeys.reviewFriendRequests: 'Freundschaftsanfragen prüfen',
  NotificationKeys.groupRequests: 'Gruppenanfragen',
  NotificationKeys.reviewGroupRequests: 'Gruppenanfragen prüfen',

  //Profile

  ProfileKeys.profilerefresh: 'Profil aktualisieren',
  ProfileKeys.profileEdit: 'Profil bearbeiten',
  ProfileKeys.profilecopylink: 'Profil-Link kopieren',
  ProfileKeys.profileblock: 'Benutzer blockieren',
  ProfileKeys.profilereport: 'Profil melden',
  ProfileKeys.profileremovefriend: 'Aus Freunde entfernen',
  ProfileKeys.profilepoke: 'Anstupsen',

  ProfileKeys.profilePost: 'Beitrag',
  ProfileKeys.profilefriend: 'Freund',
  ProfileKeys.profileaward: 'Auszeichnung',

  ProfileKeys.profilePosts: 'Beiträge',
  ProfileKeys.profileMedia: 'Medien',
  ProfileKeys.profileMentions: 'Erwähnungen',

  ProfileKeys.profilefirstname: 'Vorname',
  ProfileKeys.profilelastname: 'Nachname',
  ProfileKeys.profileaboutme: 'Über mich',
  ProfileKeys.profileemail: 'E-Mail',
  ProfileKeys.profilelocation: 'Ort',
  ProfileKeys.profilebirthdate: 'Geburtsdatum',
  ProfileKeys.profilephonenumber: 'Telefonnummer',
  ProfileKeys.profilecheckpassword: 'Passwort überprüfen',

  ProfileKeys.profileselectcountry: 'Land auswählen',
  ProfileKeys.profileselectcity: 'Stadt auswählen',

  //Chat
  ChatKeys.chat: 'Chats',
  ChatKeys.chatyournote: 'Ihre Notiz',
  ChatKeys.chatshareasong: 'Ein Lied teilen',
  ChatKeys.chatnewchat: 'Neuer Chat',
  ChatKeys.chatwritemessage: 'Nachricht schreiben',

  ChatKeys.chatTargetAudience: 'Zielgruppe',

  //Group
  GroupKeys.createGroup: 'Gruppe erstellen',
  GroupKeys.groupName: 'Gruppenname',
  GroupKeys.groupShortname: 'Gruppenabkürzung',

  GroupKeys.groupkickuser: 'Benutzer aus der Gruppe werfen',
  GroupKeys.groupInviteuser: 'Benutzer in die Gruppe einladen',
  GroupKeys.groupInviteNumberuserSelected:
      'Ausgewählte Anzahl der eingeladenen Benutzer',
  GroupKeys.groupMember: 'Gruppenmitglied',
  GroupKeys.groupLogo: 'Gruppenlogo',
  GroupKeys.groupbanner: 'Gruppenbanner',
  GroupKeys.groupdescription: 'Gruppenbeschreibung',
  GroupKeys.groupwebsite: 'Gruppenwebsite',
  GroupKeys.groupisJoinable: 'Gruppe beitrittfähig',

  //School
  SchoolKeys.joinSchool: 'Schule beitreten',
  SchoolKeys.schoolPassword: 'Passwort',
  SchoolKeys.schoolJoin: 'Beitreten',

  //Food
  FoodKeys.orderExplain:
      'Bitte scannen Sie an der Kasse, um Ihre Bestellung aufzugeben.',
  FoodKeys.foodProduct: 'Produkt',
  FoodKeys.foodPrice: 'Preis',

  //Poll

  PollKeys.createPoll: 'Umfrage erstellen',
  PollKeys.pollquestion: 'Umfrage Frage',
  PollKeys.pollanswers: 'Umfrage Antworten',
  PollKeys.pollOption: 'Option',
  PollKeys.pollAddOption: 'Option hinzufügen',

  PollKeys.selectHour: 'Stunde auswählen',
  PollKeys.selectDate: 'Datum auswählen',

  PollKeys.selectPollMultipleChoice: 'Mehrfachauswahl',
  PollKeys.selectPollCheckboxes: 'Kontrollkästchen',
  PollKeys.selectPollShortAnswer: 'Kurzantwort',

  PollKeys.pollExpired: 'Abgelaufen',
  PollKeys.pollVoted: 'Abgestimmt',
  PollKeys.pollnotVoted: 'Nicht abgestimmt',

  //Invite
  InviteKeys.normalAccount: 'Normales Konto',
  InviteKeys.verifiedAccount: 'Verifiziertes Konto',
  InviteKeys.sendVerificationCode: 'Verifizierungscode senden',

  // JoinUs
  JoinUsKeys.phoneNumberRegistered:
      'Die Telefonnummer muss im System registriert sein.',
  JoinUsKeys.profilePhoto:
      'Das Profilbild muss sich vom Standard-Logo unterscheiden.',
  JoinUsKeys.noPenalty: 'Es wurden keine Strafen verhängt.',
  JoinUsKeys.noProvocation: 'Es darf keine Provokation anderer gegeben haben.',

  JoinUsKeys.selectAnItem: 'Wählen Sie einen Artikel',
  JoinUsKeys.selectAPosition: 'Wählen Sie eine Position',
  JoinUsKeys.whyJoinTheTeam: 'Warum möchten Sie dem Team beitreten?',
  JoinUsKeys.whyChooseThisPermission:
      'Warum haben Sie diese Berechtigung gewählt?',
  JoinUsKeys.howManyDaysPerWeek:
      'Wie viele Tage pro Woche können Sie sich engagieren?',

  //Event
  EventKeys.eventRules: 'Regeln',
  EventKeys.eventcoordinator: 'Koordinator',
  EventKeys.eventdescriptions: 'Beschreibungen',
  EventKeys.eventParticipationEndedExplain:
      'Die Teilnahmefrist für das Event ist abgelaufen. Wenn Sie denken, dass dies ein Fehler ist, kontaktieren Sie bitte die Behörden.',
  EventKeys.alreadyJoinedEventWithDeadline:
      'Sie haben bereits am Event teilgenommen. Die Frist für die Stornierung ist 30 Minuten vor Beginn des Events.',
  EventKeys.readAndAgreeRules:
      'Ich habe die Regeln gelesen, verstanden und akzeptiere sie.',
  //Settings
  SettingsKeys.translation: 'Übersetzung',
  SettingsKeys.settings: 'Einstellungen',
  SettingsKeys.lastFailedLogin: 'Fehlgeschlagene Anmeldung',

  SettingsKeys.applicationAndMedia: 'Anwendung und Medien',
  SettingsKeys.devicePermissions: 'Geräteeinstellungen',
  SettingsKeys.downloadAndArchive: 'Herunterladen und Archivieren',
  SettingsKeys.dataSaver: 'Daten-Sparer',
  SettingsKeys.languages: 'Sprachen',
  SettingsKeys.notifications: 'Benachrichtigungen',
  SettingsKeys.blockedList: 'Gesperrte Liste',
  SettingsKeys.moreInformationAndSupport:
      'Mehr Informationen und Unterstützung',
  SettingsKeys.help: 'Hilfe',
  SettingsKeys.accountStatus: 'Kontostatus',
  SettingsKeys.about: 'Über',
  SettingsKeys.addAccount: 'Konto hinzufügen',
  SettingsKeys.logOut: 'Abmelden',
  SettingsKeys.version: 'Version',

  //Drawer
  DrawerKeys.drawerMeeting: 'Besprechung',
  DrawerKeys.drawerNews: 'Nachrichten',
  DrawerKeys.drawerMyGroups: 'Meine Gruppen',
  DrawerKeys.drawerMyGroupscreate: 'Gruppe erstellen',
  DrawerKeys.drawerMySchools: 'Meine Schulen',
  DrawerKeys.drawerMySchoolsjoin: 'Schule beitreten',

  DrawerKeys.drawerFood: 'Essen',
  DrawerKeys.drawerGames: 'Spiele',
  DrawerKeys.drawerEvents: 'Veranstaltungen',
  DrawerKeys.drawerPolls: 'Umfragen',
  DrawerKeys.drawerInvite: 'Einladen',
  DrawerKeys.drawerJoinUs: 'Schließe dich uns an',
  DrawerKeys.drawerSettings: 'Einstellungen',

  //Login
  LoginKeys.loginKeysUsernameoremail: 'Benutzername / E-Mail',
  LoginKeys.loginKeysPassword: 'Passwort',
  LoginKeys.loginKeysLogin: 'Anmelden',
  LoginKeys.loginKeysForgotmypassword: 'Passwort vergessen',
  LoginKeys.loginKeysSignup: 'Registrieren',
  LoginKeys.loginKeysHaveyougotaccount: 'Hast du ein Konto?',
  LoginKeys.loginKeysPrivacyPolicy: 'Datenschutzrichtlinie',
  LoginKeys.loginKeysTermsAndConditions:
      'Nutzungsbedingungen / Benutzerpolitik',
  LoginKeys.loginKeysacceptanceMessage:
      'Durch die Fortsetzung akzeptieren Sie die Nutzungsbedingungen und die Datenschutzrichtlinie.',

  //Register
  RegisterKeys.registerKeysfirstname: 'Vorname',
  RegisterKeys.registerKeyslastname: 'Nachname',
  RegisterKeys.registerKeysusername: 'Benutzername',
  RegisterKeys.registerKeysemail: 'E-Mail',
  RegisterKeys.registerKeyspassword: 'Passwort',
  RegisterKeys.registerKeysrepeatpassword: 'Passwort wiederholen',
  RegisterKeys.registerKeysinvitecode: 'Einladungscode',
  RegisterKeys.registerKeyssignup: 'Registrieren',
  RegisterKeys.registerKeyssignin: 'Anmelden',
  RegisterKeys.registerKeysifyouhaveaccount: 'Wenn du ein Konto hast',

  //ResetPassword
  ResetPasswordKeys.resetPasswordKeysusername: 'Benutzername',
  ResetPasswordKeys.resetPasswordKeysemail: 'E-Mail',
  ResetPasswordKeys.resetPasswordKeysifyourememberyourpassword:
      'Wenn du dein Passwort erinnerst',
  ResetPasswordKeys.resetPasswordKeyscontinue: 'Fortfahren',
  ResetPasswordKeys.resetPasswordKeyssignin: 'Anmelden',
  ResetPasswordKeys.resetPasswordKeyscode: 'Code',
  ResetPasswordKeys.resetPasswordKeyscreatepassword: 'Passwort erstellen',
  ResetPasswordKeys.resetPasswordKeysrepeatpassword: 'Passwort wiederholen',
  ResetPasswordKeys.resetPasswordKeysrepeatsendcode: 'Code erneut senden',
  ResetPasswordKeys.resetPasswordKeyssave: 'Speichern',

  // BlockedListKeys
  BlockedListKeys.noBlockedAccounts: 'Keine blockierten Konten',
  BlockedListKeys.unblock: 'Entsperren',

  // DevicePermissionKeys
  DevicePermissionKeys.deviceCamera: 'Kamera',
  DevicePermissionKeys.deviceContact: 'Kontakt',
  DevicePermissionKeys.deviceLocation: 'Standort',
  DevicePermissionKeys.deviceMicrpohone: 'Mikrofon',
  DevicePermissionKeys.deviceNotifications: 'Benachrichtigungen',
  DevicePermissionKeys.deviceGranted: 'Gewährt',
  DevicePermissionKeys.deviceDenied: 'Abgelehnt',
  DevicePermissionKeys.devicePermanentlyDenied: 'Dauerhaft abgelehnt',

  //Data Saver
  DataSaverKeys.useLessCellularData: 'Weniger mobile Daten verwenden',
  DataSaverKeys.useLessCellularDataExplain:
      "Neue Seite wird nicht geladen, bis die aktuelle Seite beendet ist.",

  DataSaverKeys.uploadMediaInTheLowestQuality:
      'Medien in der niedrigsten Qualität hochladen',
  DataSaverKeys.uploadMediaInTheLowestQualityExplain:
      "Medien werden in der niedrigsten Qualität angezeigt, was störend sein kann.",

  DataSaverKeys.disableAutoplayVideos: 'Autoplay-Videos',
  DataSaverKeys.disableAutoplayVideosExplain:
      "Stoppen Sie das automatische Abspielen von Videos.",

  // Notifications
  NotificationsKeys.commentLikes: "Kommentar-Likes",
  NotificationsKeys.commentLikesExplain:
      "Benachrichtigt, wenn Ihre Kommentare geliked werden",

  NotificationsKeys.postLikes: "Post-Likes",
  NotificationsKeys.postLikesExplain:
      "Benachrichtigt, wenn Ihre Posts geliked werden",

  NotificationsKeys.comment: "Kommentare",
  NotificationsKeys.commentExplain:
      "Benachrichtigt, wenn Ihre Posts Kommentare erhalten",

  NotificationsKeys.commentReplies: "Kommentar-Antworten",
  NotificationsKeys.commentRepliesExplain:
      "Benachrichtigt, wenn jemand auf Ihren Kommentar antwortet",

  NotificationsKeys.event: "Veranstaltungen",
  NotificationsKeys.eventExplain:
      "Benachrichtigt über alle veranstaltungsbezogenen Ankündigungen",

  NotificationsKeys.birthdays: "Geburtstage",
  NotificationsKeys.birthdaysExplain:
      "Benachrichtigt über die Geburtstage Ihrer Freunde",

  NotificationsKeys.messages: "Nachrichten",
  NotificationsKeys.messagesExplain:
      "Benachrichtigt, wenn Sie eine neue Nachricht erhalten",

  NotificationsKeys.calls: "Anrufe",
  NotificationsKeys.callsExplain: "Benachrichtigt, wenn Sie angerufen werden",

  NotificationsKeys.mentions: "Erwähnungen",
  NotificationsKeys.mentionsExplain:
      "Benachrichtigt, wenn Sie in einem Post oder Kommentar erwähnt werden",

  // Help
  HelpKeys.reportIssue: "Problem melden",
  HelpKeys.reportIssueExplain:
      "Ermöglicht es Ihnen, Probleme zu melden, auf die Sie stoßen.",

  HelpKeys.supportRequests: "Support-Anfragen",
  HelpKeys.supportRequestsExplain:
      "Benachrichtigt Sie, wenn Sie eine Support-Anfrage erhalten.",

  //AccountStatus

  AccountStatusKeys.accountStatusabout:
      "Sie können hier alle Aktionen verfolgen, die gegen die Regeln in Ihrem Konto oder Inhalt verstoßen.",
  AccountStatusKeys.removedContent: "Entfernter Inhalt",
  AccountStatusKeys.removedContentExplain:
      "Benachrichtigt Sie über Inhalte, die aus Ihrem Konto entfernt wurden.",

  AccountStatusKeys.myRestrictions: "Meine Einschränkungen",
  AccountStatusKeys.myRestrictionsExplain:
      "Zeigt die auf Ihr Konto angewendeten Einschränkungen an.",

  //About
  AboutKeys.aboutYourAccount: 'Über Ihr Konto',
  AboutKeys.privacyPolicy: 'Datenschutzrichtlinie',
  AboutKeys.termsOfService: 'Nutzungsbedingungen',
  AboutKeys.openSourceLibraries: 'Open-Source-Bibliotheken',
};
