import 'package:ARMOYU/app/translations/app_translation.dart';

Map<String, String> tr = {
  SettingsKeys.currentLanguage: 'Türkçe',
  SettingsKeys.hello: 'Merhaba Dünya',
  SettingsKeys.translation: 'Çeviri',
  SettingsKeys.settings: 'Ayarlar',
  SettingsKeys.applicationAndMedia: 'Uygulama ve Medya',
  SettingsKeys.devicePermissions: 'Cihaz İzinleri',
  SettingsKeys.downloadAndArchive: 'İndirme ve Arşivleme',
  SettingsKeys.dataSaver: 'Veri Tasarrufu',
  SettingsKeys.languages: 'Diller',
  SettingsKeys.notifications: 'Bildirimler',
  SettingsKeys.blockedList: 'Engellenenler',
  SettingsKeys.moreInformationAndSupport: 'Daha Fazla Bilgi ve Destek',
  SettingsKeys.help: 'Yardım',
  SettingsKeys.accountStatus: 'Hesap Durumu',
  SettingsKeys.about: 'Hakkında',
  SettingsKeys.addAccount: 'Hesap Ekle',
  SettingsKeys.logOut: 'Çıkış Yap',
  SettingsKeys.version: 'Versiyon',

  //Drawer
  DrawerKeys.drawerMeeting: 'Toplantı',
  DrawerKeys.drawerNews: 'Haberler',
  DrawerKeys.drawerMyGroups: 'Gruplarım',
  DrawerKeys.drawerMyGroupscreate: 'Grup Oluştur',
  DrawerKeys.drawerMySchools: 'Okullarım',
  DrawerKeys.drawerMySchoolsjoin: 'Okula Katıl',
  DrawerKeys.drawerFood: 'Yemek',
  DrawerKeys.drawerGames: 'Oyun',
  DrawerKeys.drawerEvents: 'Etkinlikler',
  DrawerKeys.drawerPolls: 'Anketler',
  DrawerKeys.drawerInvite: 'Davet Et',
  DrawerKeys.drawerJoinUs: 'Bize Katıl',
  DrawerKeys.drawerSettings: 'Ayarlar',

  //Login
  LoginKeys.loginKeysUsernameoremail: 'Kullanıcı Adı veya E-posta',
  LoginKeys.loginKeysPassword: 'Şifre',
  LoginKeys.loginKeysLogin: 'Giriş Yap',
  LoginKeys.loginKeysForgotmypassword: 'Şifremi Unuttum',
  LoginKeys.loginKeysSignup: 'Kayıt Ol',
  LoginKeys.loginKeysHaveyougotaccount: 'Hesabınız var mı?',
  LoginKeys.loginKeysPrivacyPolicy: 'Gizlilik Politikası',
  LoginKeys.loginKeysTermsAndConditions: 'Hizmet Şartları/Kullanıcı Politikası',
  LoginKeys.loginKeysacceptanceMessage: 'nı kabul etmiş olursunuz.',

  //Register
  RegisterKeys.registerKeysfirstname: 'Ad',
  RegisterKeys.registerKeyslastname: 'Soyad',
  RegisterKeys.registerKeysusername: 'Kullanıcı Adı',
  RegisterKeys.registerKeysemail: 'E-posta',
  RegisterKeys.registerKeyspassword: 'Şifre',
  RegisterKeys.registerKeysrepeatpassword: 'Şifre Tekrarı',
  RegisterKeys.registerKeysinvitecode: 'Davet Kodu',
  RegisterKeys.registerKeyssignup: 'Kayıt Ol',
  RegisterKeys.registerKeyssignin: 'Giriş Yap',
  RegisterKeys.registerKeysifyouhaveaccount: 'Hesabın varsa',

  //ResetPassword
  ResetPasswordKeys.resetPasswordKeysusername: 'Kullanıcı Adı',
  ResetPasswordKeys.resetPasswordKeysemail: 'E-posta',
  ResetPasswordKeys.resetPasswordKeysifyourememberyourpassword:
      'Şifreyi hatırlarsan',
  ResetPasswordKeys.resetPasswordKeyscontinue: 'Devam',
  ResetPasswordKeys.resetPasswordKeyssignin: 'Giriş Yap',
  ResetPasswordKeys.resetPasswordKeyscode: 'Code',
  ResetPasswordKeys.resetPasswordKeyscreatepassword: 'Parola Oluştur',
  ResetPasswordKeys.resetPasswordKeysrepeatpassword: 'Parola Tekrarı',
  ResetPasswordKeys.resetPasswordKeysrepeatsendcode: 'Tekrar Kod Gönder',
  ResetPasswordKeys.resetPasswordKeyssave: 'Kaydet',

  // BlockedListKeys
  BlockedListKeys.noBlockedAccounts: 'Engellenen hesap yok',
  BlockedListKeys.unblock: 'Engel kaldır',

  // DevicePermissionKeys
  DevicePermissionKeys.deviceCamera: 'Kamera',
  DevicePermissionKeys.deviceContact: 'Rehber',
  DevicePermissionKeys.deviceLocation: 'Konum',
  DevicePermissionKeys.deviceMicrpohone: 'Mikrofon',
  DevicePermissionKeys.deviceNotifications: 'Bildirimler',
  DevicePermissionKeys.deviceGranted: 'İzin Verildi',
  DevicePermissionKeys.deviceDenied: 'İzin Verilmedi',
  DevicePermissionKeys.devicePermanentlyDenied: 'Kalıcı olarak izin verilmedi',

  //Data Saver
  DataSaverKeys.useLessCellularData: 'Daha az hücresel veri kullan',
  DataSaverKeys.useLessCellularDataExplain:
      "Sayfa sonuna gelmeden yeni sayfa yüklenmez.",

  DataSaverKeys.uploadMediaInTheLowestQuality: 'En düşük kalitede medya yükle',
  DataSaverKeys.uploadMediaInTheLowestQualityExplain:
      "Medyalar en düşük kalitede gösterilir bu can sıkıcı olabilir.",

  DataSaverKeys.disableAutoplayVideos: 'Videoları otomatik olarak oynatma',
  DataSaverKeys.disableAutoplayVideosExplain:
      "Otomatik video oynatmayı durdurur.",

  //Notifications
  NotificationsKeys.commentLikes: "Yorum Beğenileri",
  NotificationsKeys.commentLikesExplain: "Yorumlarınız beğenildiğinde bildirir",

  NotificationsKeys.postLikes: "Paylaşım Beğenileri",
  NotificationsKeys.postLikesExplain:
      "Paylaşımlarınız beğeni aldığında bildirir",

  NotificationsKeys.comment: "Yorumlar",
  NotificationsKeys.commentExplain:
      "Paylaşımlarınıza yorum yapıldığında bildirir",

  NotificationsKeys.commentReplies: "Yorum Yanıtları",
  NotificationsKeys.commentRepliesExplain:
      "Yorumunuza birisi yanıt verdiğinde bildirir",

  NotificationsKeys.event: "Etkinlikler",
  NotificationsKeys.eventExplain: "Etkinlik ile ilgili tüm duyuruları bildirir",

  NotificationsKeys.birthdays: "Doğum Günleri",
  NotificationsKeys.birthdaysExplain:
      "Arkadaşlarınızın doğum günlerini bildirir",

  NotificationsKeys.messages: "Mesajlar",
  NotificationsKeys.messagesExplain: "Yeni mesaj geldiğinde bildirir",

  NotificationsKeys.calls: "Aramalar",
  NotificationsKeys.callsExplain: "Birisi sizi aradığında bildirir",

  NotificationsKeys.mentions: "Bahsetmeler",
  NotificationsKeys.mentionsExplain: "Etiketlendiğiniz her şeyi bildirir",

  // Help
  HelpKeys.reportIssue: "Sorun Bildir",
  HelpKeys.reportIssueExplain:
      "Karşılaştığınız sorunları bildirmenize olanak tanır.",

  HelpKeys.supportRequests: "Destek Talepleri",
  HelpKeys.supportRequestsExplain: "Destek talebi aldığınızda sizi bildirir.",

  //AccountStatus
  AccountStatusKeys.accountStatusabout:
      "Hesabının veya içeriklerinde kurallara uygun olmayan işlemleri buradan takip edebilirsin.",

  AccountStatusKeys.removedContent: "Kaldırılan İçerikler",
  AccountStatusKeys.removedContentExplain:
      "Hesabınızdan kaldırılan içeriklerle ilgili bildirim alırsınız.",

  AccountStatusKeys.myRestrictions: "Kısıtlanmalarım",
  AccountStatusKeys.myRestrictionsExplain:
      "Hesabınıza uygulanan kısıtlamalar hakkında bilgi verir.",

  //About
  AboutKeys.aboutYourAccount: 'Hesabın Hakkında',
  AboutKeys.privacyPolicy: 'Gizlilik İlkesi',
  AboutKeys.termsOfService: 'Kullanım Koşulları',
  AboutKeys.openSourceLibraries: 'Açık Kaynak Kütüphaneleri',
};
