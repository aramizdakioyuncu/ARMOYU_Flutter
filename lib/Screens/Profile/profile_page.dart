import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/blocking.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/Social/comment.dart';
import 'package:ARMOYU/Models/Social/like.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/post.dart';
import 'package:ARMOYU/Models/user.dart';

import 'package:ARMOYU/Screens/Profile/friendlist_page.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:ARMOYU/Widgets/detectabletext.dart';
import 'package:ARMOYU/Widgets/text.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/posts.dart';
import 'package:skeletons/skeletons.dart';

class ProfilePage extends StatefulWidget {
  final User currentUser;
  final User profileUser;
  final bool ismyProfile;
  final ScrollController scrollController;

  const ProfilePage({
    super.key,
    required this.currentUser,
    required this.profileUser,
    required this.ismyProfile,
    required this.scrollController,
  });
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

late TabController tabController;
int _tabinitialIndex = 0;

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  bool refreshprofilepageStatus = false;
  bool refreshprofilepageArrow = false;
  User userProfile = User();
  bool isFriend = false;

  bool isbeFriend = false;
  List<String> listFriendTOP3 = [];
  String friendTextLine = "";

  bool isAppBarExpanded = true;
  bool galleryproccess = false;

  String friendStatus = "";
  Color friendStatuscolor = Colors.blue;

  int postscounter = 1;
  bool postsfetchproccess = false;

  int postscounterv2 = 1;
  bool postsfetchProccessv2 = false;

  int gallerycounter = 1;
  bool firstgalleryfetcher = false;

  bool firstFetchPosts = true;
  bool firstFetchGallery = true;
  bool firstFetchTaggedPost = true;

  bool _changeavatarStatus = false;
  bool _changebannerStatus = false;
  final ScrollController _scrollRefresh = ScrollController();

  @override
  void initState() {
    super.initState();

    test();

    tabController = TabController(
      initialIndex: _tabinitialIndex,
      length: 3,
      vsync: this,
    );

    _scrollRefresh.addListener(() {
      // log(_scrollRefresh.position.pixels.toString());

      if (_scrollRefresh.position.pixels <= -50) {
        refreshprofilepageArrow = false;

        setstatefunction();

        if (!refreshprofilepageStatus) {
          _handleRefresh(myProfileRefresh: true);

          refreshprofilepageStatus = true;
          // setstatefunction();
        }
      }

      if (_scrollRefresh.position.pixels < -10) {
        if (!refreshprofilepageStatus) {
          refreshprofilepageArrow = true;
          setstatefunction();
        }
      }

      if (_scrollRefresh.position.pixels == 0) {
        refreshprofilepageArrow = false;
        setstatefunction();
      }
    });
  }

  @override
  void dispose() {
    // TEST.cancel();
    super.dispose();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> userblockingfunction() async {
    if (mounted) {
      Navigator.pop(context);
    }

    FunctionsBlocking f = FunctionsBlocking(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.add(userProfile.userID!);

    ARMOYUWidget.toastNotification(response["aciklama"]);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
  }

  List<Widget> widgetPosts = [];
  List<Widget> widgetTaggedPosts = [];
  List<Media> medialist = [];

  profileloadPosts(
      int page, int userID, List<Widget> list, String category) async {
    if (postsfetchproccess) {
      return;
    }
    postsfetchproccess = true;
    setstatefunction();
    FunctionService f = FunctionService(currentUser: widget.currentUser);
    Map<String, dynamic> response =
        await f.getprofilePosts(page, userID, category);
    if (response["durum"] == 0) {
      log(response["aciklama"]);

      postsfetchproccess = false;
      setstatefunction();
      return;
    }

    if (response["icerik"].length == 0) {
      postsfetchproccess = false;

      setstatefunction();
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Media> media = [];
      List<Comment> comments = [];
      List<Like> likers = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        for (var mediaInfo in response["icerik"][i]["paylasimfoto"]) {
          media.add(
            Media(
              mediaID: mediaInfo["fotoID"],
              ownerID: response["icerik"][i]["sahipID"],
              mediaType: mediaInfo["paylasimkategori"],
              mediaDirection: mediaInfo["medyayonu"],
              mediaURL: MediaURL(
                bigURL: mediaInfo["fotourl"],
                normalURL: mediaInfo["fotoufakurl"],
                minURL: mediaInfo["fotominnakurl"],
              ),
            ),
          );
        }
      }
      for (var firstthreelike in response["icerik"][i]
          ["paylasimilkucbegenen"]) {
        likers.add(
          Like(
              likeID: firstthreelike["begeni_ID"],
              user: User(
                userID: firstthreelike["ID"],
                displayName: firstthreelike["adsoyad"],
                userName: firstthreelike["kullaniciadi"],
                avatar: Media(
                  mediaID: firstthreelike["ID"],
                  mediaURL: MediaURL(
                    bigURL: firstthreelike["avatar"],
                    normalURL: firstthreelike["avatar"],
                    minURL: firstthreelike["avatar"],
                  ),
                ),
              ),
              date: firstthreelike["begeni_zaman"]),
        );
      }
      for (var firstthreecomment in response["icerik"][i]["ilkucyorum"]) {
        comments.add(
          Comment(
              commentID: firstthreecomment["yorumID"],
              postID: firstthreecomment["paylasimID"],
              user: User(
                userID: firstthreecomment["yorumcuid"],
                displayName: firstthreecomment["yorumcuadsoyad"],
                avatar: Media(
                  mediaID: firstthreecomment["yorumcuid"],
                  mediaURL: MediaURL(
                    bigURL: firstthreecomment["yorumcuavatar"],
                    normalURL: firstthreecomment["yorumcuufakavatar"],
                    minURL: firstthreecomment["yorumcuminnakavatar"],
                  ),
                ),
              ),
              content: firstthreecomment["yorumcuicerik"],
              likeCount: firstthreecomment["yorumbegenisayi"],
              didIlike: firstthreecomment["benbegendim"] == 1 ? true : false,
              date: firstthreecomment["yorumcuzamangecen"]),
        );
      }

      bool ismelike = false;
      if (response["icerik"][i]["benbegendim"] == 1) {
        ismelike = true;
      } else {
        ismelike = false;
      }
      bool ismecomment = false;

      if (response["icerik"][i]["benyorumladim"] == 1) {
        ismecomment = true;
      } else {
        ismecomment = false;
      }
      Post post = Post(
          postID: response["icerik"][i]["paylasimID"],
          content: response["icerik"][i]["paylasimicerik"],
          postDate: response["icerik"][i]["paylasimzamangecen"],
          sharedDevice: response["icerik"][i]["paylasimnereden"],
          likesCount: response["icerik"][i]["begenisay"],
          isLikeme: ismelike,
          commentsCount: response["icerik"][i]["yorumsay"],
          iscommentMe: ismecomment,
          media: media,
          owner: User(
            userID: response["icerik"][i]["sahipID"],
            userName: response["icerik"][i]["sahipad"],
            avatar: Media(
              mediaID: response["icerik"][i]["sahipID"],
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["sahipavatarminnak"],
                normalURL: response["icerik"][i]["sahipavatarminnak"],
                minURL: response["icerik"][i]["sahipavatarminnak"],
              ),
            ),
          ),
          firstthreecomment: comments,
          firstthreelike: likers,
          location: response["icerik"][i]["paylasimkonum"]);

      list.add(
        TwitterPostWidget(
          currentUser: widget.currentUser,
          post: post,
        ),
      );

      setstatefunction();
    }
    postscounter++;
    postsfetchproccess = false;
    setstatefunction();
  }

  gallery(int page, int userID) async {
    firstgalleryfetcher = true;
    setstatefunction();

    if (galleryproccess) {
      return;
    }

    galleryproccess = true;
    setstatefunction();

    if (page == 1) {
      medialist.clear();
      setstatefunction();
    }

    FunctionsMedia f = FunctionsMedia(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.fetch(userID, "-1", page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      log("Sayfa Sonu");

      galleryproccess = false;
      setstatefunction();
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      medialist.add(
        Media(
          mediaID: response["icerik"][i]["media_ID"],
          ownerID: response["icerik"][i]["media_ownerID"],
          ownerusername: response["icerik"][i]["media_ownerusername"],
          owneravatar: response["icerik"][i]["media_owneravatar"],
          mediaTime: response["icerik"][i]["media_time"],
          mediaType: response["icerik"][i]["fotodosyatipi"],
          mediaURL: MediaURL(
            bigURL: response["icerik"][i]["fotoorijinalurl"],
            normalURL: response["icerik"][i]["fotoufaklikurl"],
            minURL: response["icerik"][i]["fotominnakurl"],
          ),
        ),
      );
      setstatefunction();
    }
    galleryproccess = false;
    gallerycounter++;
    setstatefunction();
  }

  profileloadtaggedPosts(
      int page, int userID, List<Widget> list, String category) async {
    if (postsfetchProccessv2) {
      return;
    }

    postsfetchProccessv2 = true;
    setstatefunction();

    FunctionService f = FunctionService(currentUser: widget.currentUser);
    Map<String, dynamic> response =
        await f.getprofilePosts(page, userID, category);
    if (response["durum"] == 0) {
      log(response["aciklama"]);

      postsfetchProccessv2 = false;
      setstatefunction();
      return;
    }

    if (response["icerik"].length == 0) {
      postsfetchProccessv2 = false;
      setstatefunction();
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Media> media = [];
      List<Comment> comments = [];
      List<Like> likers = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        for (var mediaInfo in response["icerik"][i]["paylasimfoto"]) {
          media.add(
            Media(
              mediaID: mediaInfo["fotoID"],
              ownerID: response["icerik"][i]["sahipID"],
              mediaType: mediaInfo["paylasimkategori"],
              mediaDirection: mediaInfo["medyayonu"],
              mediaURL: MediaURL(
                bigURL: mediaInfo["fotoufakurl"],
                normalURL: mediaInfo["fotominnakurl"],
                minURL: mediaInfo["fotominnakurl"],
              ),
            ),
          );
        }
      }
      for (var firstthreelike in response["icerik"][i]
          ["paylasimilkucbegenen"]) {
        likers.add(
          Like(
              likeID: firstthreelike["begeni_ID"],
              user: User(
                userID: firstthreelike["ID"],
                displayName: firstthreelike["adsoyad"],
                userName: firstthreelike["kullaniciadi"],
                avatar: Media(
                  mediaID: firstthreelike["ID"],
                  mediaURL: MediaURL(
                    bigURL: firstthreelike["avatar"],
                    normalURL: firstthreelike["avatar"],
                    minURL: firstthreelike["avatar"],
                  ),
                ),
              ),
              date: firstthreelike["begeni_zaman"]),
        );
      }
      for (var firstthreecomment in response["icerik"][i]["ilkucyorum"]) {
        comments.add(
          Comment(
              commentID: firstthreecomment["yorumID"],
              postID: firstthreecomment["paylasimID"],
              user: User(
                userID: firstthreecomment["yorumcuid"],
                displayName: firstthreecomment["yorumcuadsoyad"],
                avatar: Media(
                  mediaID: firstthreecomment["yorumcuid"],
                  mediaURL: MediaURL(
                    bigURL: firstthreecomment["yorumcuavatar"],
                    normalURL: firstthreecomment["yorumcuufakavatar"],
                    minURL: firstthreecomment["yorumcuminnakavatar"],
                  ),
                ),
              ),
              content: firstthreecomment["yorumcuicerik"],
              likeCount: firstthreecomment["yorumbegenisayi"],
              didIlike: firstthreecomment["benbegendim"] == 1 ? true : false,
              date: firstthreecomment["yorumcuzamangecen"]),
        );
      }
      bool ismelike = false;
      if (response["icerik"][i]["benbegendim"] == 1) {
        ismelike = true;
      } else {
        ismelike = false;
      }
      bool ismecomment = false;

      if (response["icerik"][i]["benyorumladim"] == 1) {
        ismecomment = true;
      } else {
        ismecomment = false;
      }
      Post post = Post(
        postID: response["icerik"][i]["paylasimID"],
        content: response["icerik"][i]["paylasimicerik"],
        postDate: response["icerik"][i]["paylasimzamangecen"],
        sharedDevice: response["icerik"][i]["paylasimnereden"],
        likesCount: response["icerik"][i]["begenisay"],
        isLikeme: ismelike,
        commentsCount: response["icerik"][i]["yorumsay"],
        iscommentMe: ismecomment,
        media: media,
        owner: User(
          userID: response["icerik"][i]["sahipID"],
          userName: response["icerik"][i]["sahipad"],
          avatar: Media(
            mediaID: response["icerik"][i]["sahipID"],
            mediaURL: MediaURL(
              bigURL: response["icerik"][i]["sahipavatarminnak"],
              normalURL: response["icerik"][i]["sahipavatarminnak"],
              minURL: response["icerik"][i]["sahipavatarminnak"],
            ),
          ),
        ),
        firstthreecomment: comments,
        firstthreelike: likers,
        location: response["icerik"][i]["paylasimkonum"],
      );

      list.add(
        TwitterPostWidget(
          currentUser: widget.currentUser,
          post: post,
        ),
      );
      setstatefunction();
    }
    postscounterv2++;
    postsfetchProccessv2 = false;
    setstatefunction();
  }

  Future<void> test({bool myprofilerefresh = false}) async {
    if (widget.ismyProfile) {
      if (myprofilerefresh) {
        FunctionService f = FunctionService(currentUser: widget.currentUser);
        log("1--1");

        Map<String, dynamic> response =
            await f.lookProfile(widget.currentUser.userID!);
        userProfile = ARMOYUFunctions.userfetch(response["icerik"]);
      } else {
        userProfile = widget.currentUser;
      }
    } else {
      Map<String, dynamic> response = {};
      if (widget.currentUser.userID == null &&
          widget.currentUser.userName != null) {
        log("->>kullanıcıadına  göre oyuncu bul!");

        FunctionService f = FunctionService(currentUser: widget.currentUser);
        Map<String, dynamic> response =
            await f.lookProfilewithusername(widget.profileUser.userName!);

        if (response["durum"] == 0) {
          log("Oyuncu bulunamadı");
          return;
        }

        if (response["aciklama"] == "Oyuncu bilgileri yanlış!") {
          return;
        }
        //Kullanıcı adında birisi var
        Map<String, dynamic> oyuncubilgi = response["icerik"];

        userProfile = ARMOYUFunctions.userfetch(oyuncubilgi);

        if (oyuncubilgi["arkadasdurum"] == "1") {
          isFriend = true;
          isbeFriend = false;
        } else if (oyuncubilgi["arkadasdurum"] == "2") {
          isFriend = false;
          isbeFriend = false;
        } else {
          isFriend = false;
          isbeFriend = true;
        }
        listFriendTOP3.clear();
        friendTextLine = "";

        for (int i = 0; i < oyuncubilgi["ortakarkadasliste"].length; i++) {
          if (i < 2) {
            if (i == 0) {
              friendTextLine +=
                  "@${oyuncubilgi["ortakarkadasliste"][i]["oyuncukullaniciadi"]} ";
            } else {
              if (oyuncubilgi["ortakarkadasliste"].length == 2) {
                friendTextLine +=
                    "ve @${oyuncubilgi["ortakarkadasliste"][i]["oyuncukullaniciadi"]} ";
              } else {
                friendTextLine +=
                    ", @${oyuncubilgi["ortakarkadasliste"][i]["oyuncukullaniciadi"]} ";
              }
            }
          }
          listFriendTOP3
              .add(oyuncubilgi["ortakarkadasliste"][i]["oyuncuminnakavatar"]);
          setstatefunction();
        }

        if (oyuncubilgi["ortakarkadasliste"].length > 2) {
          int mutualFriend = oyuncubilgi["ortakarkadaslar"] - 2;
          friendTextLine +=
              "ve ${mutualFriend.toString()} diğer kişi ile arkadaş";
        } else if (oyuncubilgi["ortakarkadasliste"].length == 2) {
          friendTextLine += " ile arkadaş";
        } else if (oyuncubilgi["ortakarkadasliste"].length == 1) {
          friendTextLine += " ile arkadaş";
        }
        ///////
      } else {
        log("->>ID ye göre oyuncu bul!");
        FunctionService f = FunctionService(currentUser: widget.currentUser);
        response = await f.lookProfile(widget.profileUser.userID!);
        if (response["durum"] == 0) {
          log("Oyuncu bulunamadı");
          return;
        }

        Map<String, dynamic> oyuncubilgi = response["icerik"];

        userProfile = ARMOYUFunctions.userfetch(oyuncubilgi);

        if (oyuncubilgi["arkadasdurum"] == "1") {
          isFriend = true;
          isbeFriend = false;
        } else if (oyuncubilgi["arkadasdurum"] == "2") {
          isFriend = false;
          isbeFriend = false;
        } else {
          isFriend = false;
          isbeFriend = true;
        }

        listFriendTOP3.clear();
        friendTextLine = "";
        for (int i = 0; i < oyuncubilgi["ortakarkadasliste"].length; i++) {
          if (i < 2) {
            if (i == 0) {
              friendTextLine +=
                  "@${oyuncubilgi["ortakarkadasliste"][i]["oyuncukullaniciadi"]} ";
            } else {
              if (oyuncubilgi["ortakarkadasliste"].length == 2) {
                friendTextLine +=
                    "ve @${oyuncubilgi["ortakarkadasliste"][i]["oyuncukullaniciadi"]}";
              } else {
                friendTextLine +=
                    ", @${oyuncubilgi["ortakarkadasliste"][i]["oyuncukullaniciadi"]} ";
              }
            }
          }
          listFriendTOP3
              .add(oyuncubilgi["ortakarkadasliste"][i]["oyuncuminnakavatar"]);
          setstatefunction();
        }

        if (oyuncubilgi["ortakarkadasliste"].length > 2) {
          int mutualFriend = oyuncubilgi["ortakarkadaslar"] - 2;
          friendTextLine +=
              "ve ${mutualFriend.toString()} diğer kişi ile arkadaş";
        } else if (oyuncubilgi["ortakarkadasliste"].length == 2) {
          friendTextLine += " ile arkadaş";
        } else if (oyuncubilgi["ortakarkadasliste"].length == 1) {
          friendTextLine += " ile arkadaş";
        }
        /////
      }

      if (isbeFriend && !isFriend && !widget.ismyProfile) {
        friendStatus = "Arkadaş Ol";
        friendStatuscolor = Colors.blue;
      } else if (!isbeFriend && !isFriend && !widget.ismyProfile) {
        friendStatus = "İstek Gönderildi";
        friendStatuscolor = Colors.black;
      } else if (!isbeFriend && isFriend && !widget.ismyProfile) {
        friendStatus = "Mesaj Gönder";
        friendStatuscolor = Colors.blue;
      }
    }

    if (firstFetchPosts) {
      profileloadPosts(postscounter, userProfile.userID!, widgetPosts, "");
      firstFetchPosts = false;
      setstatefunction();
    }
    if (firstFetchGallery) {
      gallery(gallerycounter, userProfile.userID!);

      firstFetchGallery = false;
      setstatefunction();
    }

    if (firstFetchTaggedPost) {
      profileloadtaggedPosts(postscounterv2, userProfile.userID!,
          widgetTaggedPosts, "etiketlenmis");
      firstFetchTaggedPost = false;
      setstatefunction();
    }

    refreshprofilepageStatus = false;
    setstatefunction();
  }

  Future<void> _handleRefresh({bool myProfileRefresh = false}) async {
    refreshprofilepageStatus = true;
    setstatefunction();
    log("--BAŞLADI---");

    await test(myprofilerefresh: myProfileRefresh);
    log("---BİTTİ--");
    refreshprofilepageStatus = false;
    setstatefunction();
  }

  Future<void> defaultavatar() async {
    Navigator.pop(context);

    if (_changeavatarStatus) {
      return;
    }

    _changeavatarStatus = true;
    setstatefunction();
    FunctionsProfile f = FunctionsProfile(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.defaultavatar();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);
      _changeavatarStatus = false;
      setstatefunction();
      return;
    }

    widget.currentUser.avatar = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    userProfile.avatar = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _changeavatarStatus = false;
    setstatefunction();
  }

  Future<void> defaultbanner() async {
    Navigator.pop(context);

    if (_changebannerStatus) {
      return;
    }

    _changebannerStatus = true;
    setstatefunction();
    FunctionsProfile f = FunctionsProfile(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.defaultbanner();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);
      _changebannerStatus = false;
      setstatefunction();
      return;
    }

    widget.currentUser.banner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    userProfile.banner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _changebannerStatus = false;
    setstatefunction();
  }

  Future<void> changeavatar() async {
    Navigator.pop(context);

    if (_changeavatarStatus) {
      ARMOYUWidget.toastNotification("Lütfen görselin yüklenmesini bekleyin!");
      return;
    }

    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.square,
    );
    if (selectedImage == null) {
      return;
    }

    _changeavatarStatus = true;
    setstatefunction();

    FunctionsProfile f = FunctionsProfile(currentUser: widget.currentUser);
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);
    Map<String, dynamic> response = await f.changeavatar(imagePath);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);
      _changeavatarStatus = false;
      setstatefunction();
      return;
    }

    widget.currentUser.avatar = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );
    _changeavatarStatus = false;
    setstatefunction();
    await _handleRefresh();
  }

  Future<void> changebanner() async {
    Navigator.pop(context);

    if (_changebannerStatus) {
      ARMOYUWidget.toastNotification(
          "Lütfen arkaplan görselinin yüklenmesini bekleyin!");
      return;
    }
    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.ratio16x9,
    );
    if (selectedImage == null) {
      return;
    }

    _changebannerStatus = true;
    setstatefunction();

    FunctionsProfile f = FunctionsProfile(currentUser: widget.currentUser);
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);
    Map<String, dynamic> response = await f.changebanner(imagePath);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);

      _changebannerStatus = false;
      setstatefunction();
      return;
    }
    widget.currentUser.banner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _changebannerStatus = false;
    setstatefunction();
    await _handleRefresh();
  }

  Future<void> friendrequest() async {
    FunctionsProfile f = FunctionsProfile(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.friendrequest(userProfile.userID!);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    friendStatus = "Bekleniyor";
    friendStatuscolor = Colors.black;
  }

  Future<void> cancelfriendrequest() async {
    log("istek iptal edilecek ");
  }

  Widget widgetFriendList(bool isclip, double left, String imageUrl) {
    if (isclip) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: 25,
            height: 25,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }
    return Positioned(
      left: left,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: 25,
          height: 25,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: NestedScrollView(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: !widget.ismyProfile ? true : false,
              backgroundColor: ARMOYU.appbarColor,
              expandedHeight: ARMOYU.screenHeight * 0.25,
              leading: widget.ismyProfile
                  ? null
                  : IconButton(
                      onPressed: () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
              title: widget.ismyProfile
                  ? null
                  : userProfile.displayName == null
                      ? const SkeletonLine(
                          style: SkeletonLineStyle(width: 200),
                        )
                      : Text(
                          userProfile.displayName.toString(),
                        ),
              actions: <Widget>[
                userProfile.userID == null
                    ? const SizedBox()
                    : IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                            width: ARMOYU.screenWidth / 4,
                                            height: 5,
                                          ),
                                        ),
                                        Visibility(
                                          visible: widget.ismyProfile,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              ARMOYUFunctions functions =
                                                  ARMOYUFunctions(
                                                      currentUser:
                                                          widget.currentUser);
                                              functions.profileEdit(
                                                context,
                                                setstatefunction,
                                              );
                                            },
                                            child: const ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text("Profili Düzenle"),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: const ListTile(
                                            leading: Icon(Icons.content_copy),
                                            title:
                                                Text("Profil linkini kopyala."),
                                          ),
                                        ),
                                        const Divider(),
                                        Visibility(
                                          visible: !widget.ismyProfile,
                                          child: InkWell(
                                            onTap: () => userblockingfunction(),
                                            child: const ListTile(
                                              textColor: Colors.red,
                                              leading: Icon(
                                                Icons.person_off_outlined,
                                                color: Colors.red,
                                              ),
                                              title:
                                                  Text("Kullanıcıyı Engelle."),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: !widget.ismyProfile,
                                          child: InkWell(
                                            onTap: () {},
                                            child: const ListTile(
                                              textColor: Colors.red,
                                              leading: Icon(
                                                Icons.flag_outlined,
                                                color: Colors.red,
                                              ),
                                              title: Text("Profili bildir."),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: isFriend,
                                          child: InkWell(
                                            onTap: () async {
                                              FunctionsProfile f =
                                                  FunctionsProfile(
                                                      currentUser:
                                                          widget.currentUser);
                                              Map<String, dynamic> response =
                                                  await f.friendremove(
                                                      userProfile.userID!);
                                              if (response["durum"] == 0) {
                                                log(response["aciklama"]);
                                                return;
                                              }
                                            },
                                            child: const ListTile(
                                              textColor: Colors.red,
                                              leading: Icon(
                                                Icons.person_remove,
                                                color: Colors.pink,
                                              ),
                                              title:
                                                  Text("Arkadaşlıktan Çıkar."),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: isFriend,
                                          child: InkWell(
                                            onTap: () async {
                                              FunctionsProfile f =
                                                  FunctionsProfile(
                                                      currentUser:
                                                          widget.currentUser);
                                              Map<String, dynamic> response =
                                                  await f.userdurting(
                                                      userProfile.userID!);
                                              if (response["durum"] == 0) {
                                                log(response["aciklama"]);
                                                ARMOYUWidget.toastNotification(
                                                    response["aciklama"]
                                                        .toString());
                                                return;
                                              }
                                            },
                                            child: const ListTile(
                                              textColor: Colors.orange,
                                              leading: Icon(
                                                Icons.local_fire_department,
                                                color: Colors.pink,
                                              ),
                                              title: Text("Profili Dürt."),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                const SizedBox(width: 10),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: GestureDetector(
                  onTap: () {
                    if (userProfile.banner == null) {
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MediaViewer(
                          currentUser: widget.currentUser,
                          media: [userProfile.banner!],
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    if (!widget.ismyProfile) {
                      return;
                    }
                    showModalBottomSheet<void>(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      width: ARMOYU.screenWidth / 4,
                                      height: 5,
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.ismyProfile,
                                    child: InkWell(
                                      onTap: () async {
                                        await changebanner();
                                      },
                                      child: const ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Arkaplan değiştir."),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Visibility(
                                    visible: widget.ismyProfile,
                                    child: InkWell(
                                      onTap: () async => await defaultbanner(),
                                      child: const ListTile(
                                        textColor: Colors.red,
                                        leading: Icon(
                                          Icons.person_off_outlined,
                                          color: Colors.red,
                                        ),
                                        title: Text("Varsayılana dönder."),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: userProfile.banner == null
                      ? null
                      : Container(
                          height: ARMOYU.screenHeight * 0.25,
                          width: ARMOYU.screenWidth,
                          decoration: BoxDecoration(
                            image: _changebannerStatus
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter: refreshprofilepageStatus
                                        ? ColorFilter.mode(
                                            Colors.black.withOpacity(
                                              0.8,
                                            ),
                                            BlendMode.darken,
                                          )
                                        : ColorFilter.mode(
                                            Colors.black.withOpacity(
                                              0.0,
                                            ),
                                            BlendMode.darken,
                                          ),
                                    image: CachedNetworkImageProvider(
                                      userProfile.banner!.mediaURL.minURL,
                                    ),
                                  ),
                          ),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollRefresh,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: ARMOYU.screenHeight * 0.25,
                                  width: ARMOYU.screenWidth,
                                  child: _changebannerStatus
                                      ? const CupertinoActivityIndicator()
                                      : null,
                                ),
                                SizedBox(
                                  height: ARMOYU.screenHeight * 0.25,
                                  width: ARMOYU.screenWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: refreshprofilepageStatus,
                                        child:
                                            const CupertinoActivityIndicator(),
                                      ),
                                      Visibility(
                                        visible: refreshprofilepageArrow,
                                        child: const Icon(Icons.arrow_downward),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (userProfile.avatar == null) {
                                    return;
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MediaViewer(
                                        currentUser: widget.currentUser,
                                        media: [userProfile.avatar!],
                                        initialIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  if (!widget.ismyProfile) {
                                    return;
                                  }
                                  showModalBottomSheet<void>(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SafeArea(
                                        child: Wrap(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[900],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(30),
                                                      ),
                                                    ),
                                                    width:
                                                        ARMOYU.screenWidth / 4,
                                                    height: 5,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: widget.ismyProfile,
                                                  child: InkWell(
                                                    onTap: () async =>
                                                        await changeavatar(),
                                                    child: const ListTile(
                                                      leading: Icon(
                                                          Icons.camera_alt),
                                                      title: Text(
                                                          "Avatar değiştir."),
                                                    ),
                                                  ),
                                                ),
                                                const Divider(),
                                                Visibility(
                                                  visible: widget.ismyProfile,
                                                  child: InkWell(
                                                    onTap: () async =>
                                                        await defaultavatar(),
                                                    child: const ListTile(
                                                      textColor: Colors.red,
                                                      leading: Icon(
                                                        Icons
                                                            .person_off_outlined,
                                                        color: Colors.red,
                                                      ),
                                                      title: Text(
                                                        "Varsayılana dönder.",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: userProfile.avatar == null
                                    ? SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          width: 100,
                                          height: 100,
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                    int.parse(
                                                        "0xFF${userProfile.levelColor}"),
                                                  ),
                                                  width: 4,
                                                ),
                                                image: _changeavatarStatus
                                                    ? null
                                                    : DecorationImage(
                                                        fit: BoxFit.cover,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          userProfile.avatar!
                                                              .mediaURL.minURL,
                                                        ),
                                                      ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: _changeavatarStatus
                                                        ? const CupertinoActivityIndicator()
                                                        : null,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 26,
                                                      width: 26,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          int.parse(
                                                              "0xFF${userProfile.levelColor}"),
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.elliptical(
                                                            100,
                                                            100,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          userProfile.level
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          userProfile.xp == null
                                              ? const SkeletonLine(
                                                  style: SkeletonLineStyle(
                                                    width: 50,
                                                    padding: EdgeInsets.all(5),
                                                  ),
                                                )
                                              : CustomText.costum1(
                                                  "${userProfile.xp} XP",
                                                  weight: FontWeight.bold),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    userProfile.postsCount == null
                                        ? const SkeletonLine(
                                            style: SkeletonLineStyle(
                                              width: 35,
                                              height: 30,
                                              padding: EdgeInsets.all(2),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              CustomText.costum1(
                                                  userProfile.postsCount
                                                      .toString(),
                                                  weight: FontWeight.bold),
                                              CustomText.costum1("Gönderi"),
                                            ],
                                          ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (userProfile.postsCount ==
                                                null) {
                                              return;
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendlistPage(
                                                  currentUser: userProfile,
                                                ),
                                              ),
                                            );
                                          },
                                          child: userProfile.postsCount == null
                                              ? const SkeletonLine(
                                                  style: SkeletonLineStyle(
                                                    width: 35,
                                                    height: 30,
                                                    padding: EdgeInsets.all(2),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    CustomText.costum1(
                                                        userProfile.friendsCount
                                                            .toString(),
                                                        weight:
                                                            FontWeight.bold),
                                                    CustomText.costum1(
                                                      "Arkadaş",
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    userProfile.postsCount == null
                                        ? const SkeletonLine(
                                            style: SkeletonLineStyle(
                                              width: 35,
                                              height: 30,
                                              padding: EdgeInsets.all(2),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              CustomText.costum1(
                                                  userProfile.awardsCount
                                                      .toString(),
                                                  weight: FontWeight.bold),
                                              CustomText.costum1("Ödül"),
                                            ],
                                          ),
                                    const Spacer(),
                                    userProfile.favTeam != null
                                        ? Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (!widget.ismyProfile) {
                                                    return;
                                                  }
                                                  ARMOYUFunctions functions =
                                                      ARMOYUFunctions(
                                                          currentUser: widget
                                                              .currentUser);
                                                  functions.selectFavTeam(
                                                    context,
                                                    force: true,
                                                  );

                                                  setstatefunction();
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      userProfile.favTeam!.logo,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Column(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    userProfile.displayName == null
                        ? const SkeletonLine(
                            style: SkeletonLineStyle(
                              width: 50,
                              padding: EdgeInsets.all(5),
                            ),
                          )
                        : CustomText.costum1(
                            userProfile.displayName!,
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                    Row(
                      children: [
                        userProfile.userName == null
                            ? const SkeletonLine(
                                style: SkeletonLineStyle(
                                  width: 80,
                                  padding: EdgeInsets.all(5),
                                ),
                              )
                            : CustomText.costum1(
                                "@${userProfile.userName}",
                              ),
                        const SizedBox(width: 5),
                        userProfile.role == null
                            ? const SkeletonLine(
                                style: SkeletonLineStyle(width: 20),
                              )
                            : Text(
                                userProfile.role!.name,
                                style: TextStyle(
                                  color: Color(
                                    int.parse(
                                      "0xFF${userProfile.role!.color}",
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Visibility(
                      visible: userProfile.registerDate == null ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          userProfile.registerDate == null
                              ? const SkeletonLine(
                                  style: SkeletonLineStyle(width: 20),
                                )
                              : CustomText.costum1(
                                  userProfile.registerDate!,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: userProfile.burc == null ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.window,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          userProfile.burc == null
                              ? const SkeletonLine(
                                  style: SkeletonLineStyle(width: 100),
                                )
                              : CustomText.costum1(
                                  userProfile.burc!,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: userProfile.country == null ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          userProfile.country == null
                              ? const SkeletonLine(
                                  style: SkeletonLineStyle(width: 100),
                                )
                              : Row(
                                  children: [
                                    CustomText.costum1(
                                      "${userProfile.country?.name}",
                                    ),
                                    const SizedBox(width: 5),
                                    userProfile.province == null
                                        ? Container()
                                        : CustomText.costum1(
                                            "${userProfile.province?.name}",
                                          ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: userProfile.job == null ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.school,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          userProfile.job == null
                              ? const SkeletonLine(
                                  style: SkeletonLineStyle(width: 100),
                                )
                              : CustomText.costum1(
                                  userProfile.job!.name,
                                ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !widget.ismyProfile && listFriendTOP3.isNotEmpty,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ...List.generate(listFriendTOP3.length, (index) {
                                final reversedIndex =
                                    listFriendTOP3.length - 1 - index;
                                if (reversedIndex == 0) {
                                  return widgetFriendList(
                                    true,
                                    0,
                                    listFriendTOP3[reversedIndex].toString(),
                                  );
                                }
                                return widgetFriendList(
                                  false,
                                  reversedIndex * 15,
                                  listFriendTOP3[reversedIndex].toString(),
                                );
                              }),
                              SizedBox(width: listFriendTOP3.length * 65 / 3),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                WidgetUtility.specialText(
                                  context,
                                  currentUser: widget.currentUser,
                                  friendTextLine,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Visibility(
                          //Arkadaş ol
                          visible:
                              isbeFriend && !isFriend && !widget.ismyProfile,
                          child: Expanded(
                            child: CustomButtons.friendbuttons(
                              friendStatus,
                              friendrequest,
                              friendStatuscolor,
                            ),
                          ),
                        ),
                        Visibility(
                          //İstek Gönderildi
                          visible: !isbeFriend &&
                              !isFriend &&
                              !widget.ismyProfile &&
                              userProfile.userID != -1,
                          child: friendStatus == ""
                              ? Expanded(
                                  child: SkeletonItem(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(""),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: CustomButtons.friendbuttons(
                                    friendStatus,
                                    cancelfriendrequest,
                                    friendStatuscolor,
                                  ),
                                ),
                        ),
                        Visibility(
                          //Mesaj Gönder
                          visible:
                              !isbeFriend && isFriend && !widget.ismyProfile,
                          child: Expanded(
                            child:
                                Chat(user: userProfile, chatNotification: false)
                                    .profilesendMessage(context,
                                        currentUser: widget.currentUser),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: userProfile.aboutme == "" ? false : true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProfile.aboutme == null
                              ? const SkeletonLine(
                                  style: SkeletonLineStyle(width: 350),
                                )
                              : CustomDedectabletext.costum1(
                                  userProfile.aboutme!, 3, 13),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate:
                  Profileusersharedmedias(setstatefunction: setstatefunction),
            ),
          ];
        },
        body: TabBarView(
          physics: const ClampingScrollPhysics(),
          controller: tabController,
          children: [
            firstFetchPosts
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : widgetPosts.isEmpty
                    ? const Center(
                        child: Text("Boş"),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            final metrics = scrollNotification.metrics;

                            if (metrics.atEdge &&
                                metrics.pixels >=
                                    metrics.maxScrollExtent * 0.5) {
                              // Listenin sonuna ulaşıldı
                              log("------Paylaşım------");
                              profileloadPosts(postscounter,
                                  userProfile.userID!, widgetPosts, "");

                              return true;
                            }
                          }
                          return false;
                        },
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey('Tab1'),
                          shrinkWrap: true,
                          children: [
                            ...List.generate(
                              widgetPosts.length,
                              (index) => widgetPosts[index],
                            ),
                            Visibility(
                              visible: postsfetchproccess,
                              child: Container(
                                height: 100,
                                width: ARMOYU.screenWidth,
                                color: ARMOYU.appbarColor,
                                child: const CupertinoActivityIndicator(),
                              ),
                            ),
                          ],
                        ),
                      ),
            firstFetchGallery
                ? const Center(child: CupertinoActivityIndicator())
                : medialist.isEmpty
                    ? const Center(
                        child: Text("Boş"),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            final metrics = scrollNotification.metrics;
                            if (metrics.atEdge &&
                                metrics.pixels >=
                                    metrics.maxScrollExtent * 0.5) {
                              log("------Galeri------");
                              gallery(gallerycounter, userProfile.userID!);
                              return true;
                            }
                          }
                          return false;
                        },
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey('Tab2'),
                          shrinkWrap: true,
                          children: [
                            GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              children: List.generate(
                                medialist.length,
                                (index) => medialist[index].mediaGallery(
                                  currentUser: widget.currentUser,
                                  context: context,
                                  index: index,
                                  medialist: medialist,
                                  setstatefunction: setstatefunction,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: galleryproccess,
                              child: Container(
                                height: 100,
                                width: ARMOYU.screenWidth,
                                color: ARMOYU.appbarColor,
                                child: const CupertinoActivityIndicator(),
                              ),
                            )
                          ],
                        ),
                      ),
            firstFetchTaggedPost
                ? const Center(child: CupertinoActivityIndicator())
                : widgetTaggedPosts.isEmpty
                    ? const Center(
                        child: Text("Boş"),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            final metrics = scrollNotification.metrics;

                            if (metrics.atEdge &&
                                metrics.pixels >=
                                    metrics.maxScrollExtent * 0.5) {
                              // Listenin sonuna ulaşıldı
                              log("------Paylaşım Etiketlenmiş------");
                              profileloadtaggedPosts(
                                postscounterv2,
                                userProfile.userID!,
                                widgetTaggedPosts,
                                "etiketlenmis",
                              );

                              return true;
                            }
                          }
                          return false;
                        },
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey('Tab3'),
                          shrinkWrap: true,
                          children: [
                            ...List.generate(
                              widgetTaggedPosts.length,
                              (index) => widgetTaggedPosts[index],
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class Profileusersharedmedias extends SliverPersistentHeaderDelegate {
  final Function setstatefunction;
  Profileusersharedmedias({required this.setstatefunction});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.center,
      color: ARMOYU.backgroundcolor,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        indicatorColor: ARMOYU.color,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1('Paylaşımlar', size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1('Medya', size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1('Etiketlenmeler', size: 15.0),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
