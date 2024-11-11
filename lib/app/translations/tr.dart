import 'package:ARMOYU/app/translations/app_translation.dart';

Map<String, String> tr = {
  TranslateKeys.currentLanguage: 'Türkçe',

  //Common
  CommonKeys.search: "Ara",
  CommonKeys.empty: "Boş",
  CommonKeys.join: "Katıl",
  CommonKeys.leave: "Ayrıl",
  CommonKeys.cancel: "Vazgeç",
  CommonKeys.submit: 'Gönder',
  CommonKeys.create: 'Oluştur',
  CommonKeys.share: "Paylaş",
  CommonKeys.update: 'Güncelle',

  CommonKeys.accept: 'Kabul Et',
  CommonKeys.decline: 'Reddet',

  CommonKeys.online: 'Çevrimiçi',
  CommonKeys.offline: 'Çevrimdışı',

  CommonKeys.calling: 'Aranıyor',

  CommonKeys.second: 'Saniye',
  CommonKeys.minute: 'Dakika',
  CommonKeys.hour: 'Saat',

  CommonKeys.day: 'Gün',
  CommonKeys.month: 'Ay',
  CommonKeys.year: 'Yıl',

  CommonKeys.everyone: 'Herkes',
  CommonKeys.friends: 'Arkadaşlar',
  //Social
  SocialKeys.socialStory: 'Hikayen',

  SocialKeys.socialandnumberpersonLiked: 've #NUMBER# kişi beğendi',
  SocialKeys.socialLiked: 'beğendi',
  SocialKeys.socialViewAllComments: 'Yorumların tamamını gör',

  SocialKeys.socialComments: 'Yorumlar',
  SocialKeys.socialWriteFirstComment: 'ilk yorumu sen yaz',
  SocialKeys.socialWriteComment: 'Yorum yaz',

  SocialKeys.socialLikers: 'Beğenenler',

  SocialKeys.socialAddFavorite: 'Favorilere Ekle',
  SocialKeys.socialReport: 'Şikayet Et',
  SocialKeys.socialBlock: 'Kullanıcıyı Engelle',
  SocialKeys.socialedit: 'Paylaşımı Düzenle',
  SocialKeys.socialdelete: 'Paylaşımı Sil',

  SocialKeys.socialShare: 'Paylaşım Yap',
  SocialKeys.socialwritesomething: 'Bir Şeyler Yaz',

  //Notification
  NotificationKeys.friendRequests: 'Arkadaşlık İstekleri',
  NotificationKeys.reviewFriendRequests: 'Arkadaşlık isteklerini gözden geçir',
  NotificationKeys.groupRequests: 'Grup İstekleri',
  NotificationKeys.reviewGroupRequests: 'Grup isteklerini gözden geçir',

  //Profile
  ProfileKeys.profilerefresh: 'Profili Yenile',
  ProfileKeys.profileEdit: 'Profili Düzenle',

  ProfileKeys.profilecopylink: 'Profil Linkini Kopyala',
  ProfileKeys.profileblock: 'Profili Engelle',
  ProfileKeys.profilereport: 'Profili Bildir',
  ProfileKeys.profileremovefriend: 'Arkadaşlıktan Çıkar',
  ProfileKeys.profilepoke: 'Dürt',

  ProfileKeys.profilePost: 'Gönderi',
  ProfileKeys.profilefriend: 'Arkadaş',
  ProfileKeys.profileaward: 'Ödül',

  ProfileKeys.profilePosts: 'Paylaşımlar',
  ProfileKeys.profileMedia: 'Medya',
  ProfileKeys.profileMentions: 'Etiketlenmeler',

  ProfileKeys.profilefirstname: 'Ad',
  ProfileKeys.profilelastname: 'Soyad',
  ProfileKeys.profileaboutme: 'Hakkımda',
  ProfileKeys.profileemail: 'E-posta',
  ProfileKeys.profilelocation: 'Konum',
  ProfileKeys.profilebirthdate: 'Doğum Tarihi',
  ProfileKeys.profilephonenumber: 'Telefon Numarası',
  ProfileKeys.profilecheckpassword: 'Şifreyi Kontrol Et',

  ProfileKeys.profileselectcountry: 'Ülke Seç',
  ProfileKeys.profileselectcity: 'Şehir Seç',

  //Chat
  ChatKeys.chat: 'Sohbetler',
  ChatKeys.chatyournote: 'Notun',
  ChatKeys.chatshareasong: 'Bir şarkı paylaş',
  ChatKeys.chatnewchat: 'Yeni Sohbet',
  ChatKeys.chatwritemessage: 'Mesaj yaz',

  ChatKeys.chatTargetAudience: 'Hedef Kitle',

  //Group
  GroupKeys.createGroup: 'Grup Oluştur',
  GroupKeys.groupName: 'Grup Adı',
  GroupKeys.groupShortname: 'Grup Kısa Adı',

  //School
  SchoolKeys.joinSchool: 'Okula Katıl',
  SchoolKeys.schoolPassword: 'Parola',
  SchoolKeys.schoolJoin: 'Katıl',

  //Food
  FoodKeys.orderExplain: 'Siparişinizi vermek için kasada okutun.',
  FoodKeys.foodProduct: 'Ürün',
  FoodKeys.foodPrice: 'Fiyat',

  //Poll
  PollKeys.createPoll: 'Anket Oluştur',
  PollKeys.pollquestion: 'Anket Sorusu',
  PollKeys.pollanswers: 'Anket Cevapları',
  PollKeys.pollOption: 'Seçenek',
  PollKeys.pollAddOption: 'Seçenek Ekle',

  PollKeys.selectHour: 'Saat Seç',
  PollKeys.selectDate: 'Tarih Seç',

  PollKeys.selectPollMultipleChoice: 'Çoktan Seçmeli',
  PollKeys.selectPollCheckboxes: 'Onay Kutuları',
  PollKeys.selectPollShortAnswer: 'Kısa Yanıt',

  PollKeys.pollExpired: 'Süresi Bitti',
  PollKeys.pollVoted: 'Oylandı',
  PollKeys.pollnotVoted: 'Oylanmadı',

  //Invite
  InviteKeys.normalAccount: 'Normal Hesap',
  InviteKeys.verifiedAccount: 'Doğrulanmış Hesap',
  InviteKeys.sendVerificationCode: 'Doğrulama Kodu Gönder',

  // JoinUs
  JoinUsKeys.phoneNumberRegistered:
      'Cep telefon numarasını sisteme kayıt etmiş olmak.',
  JoinUsKeys.profilePhoto: 'Profil fotoğrafı varsayılan logodan farklı olmak.',
  JoinUsKeys.noPenalty: 'Hiç ceza almamış olmak.',
  JoinUsKeys.noProvocation: 'İnsanları kışkırtmamış olmak.',

  JoinUsKeys.selectAnItem: 'Bir öğe seçin',
  JoinUsKeys.selectAPosition: 'Bir pozisyon seçin',
  JoinUsKeys.whyJoinTheTeam: 'Neden ekibe katılmak istiyorsunuz?',
  JoinUsKeys.whyChooseThisPermission: 'Neden bu yetkiyi seçtiniz?',
  JoinUsKeys.howManyDaysPerWeek: 'Haftada kaç gün ayırabilirsiniz?',

  //Event
  EventKeys.eventRules: 'Kurallar',
  EventKeys.eventcoordinator: 'Yetkili',
  EventKeys.eventdescriptions: 'Açıklamalar',
  EventKeys.eventParticipationEndedExplain:
      'Etkinliğe katılım süresi sona erdi. Eğer bir yanlışlık olduğunu düşünüyorsanız lütfen yetkililer ile iletişime geçiniz.',
  EventKeys.alreadyJoinedEventWithDeadline:
      'Etkinliğe zaten katıldınız. Vazgeçmek için en son süre etkinlikten 30 dakika öncedir.',
  EventKeys.readAndAgreeRules: 'Kuralları okudum ve anladım, kabul ediyorum',

  //Settings
  SettingsKeys.translation: 'Çeviri',
  SettingsKeys.settings: 'Ayarlar',
  SettingsKeys.lastFailedLogin: 'Hatalı Giriş',

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
