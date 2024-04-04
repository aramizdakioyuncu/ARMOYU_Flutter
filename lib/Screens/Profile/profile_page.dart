// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Functions/API_Functions/blocking.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/post.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';

import 'package:ARMOYU/Screens/Profile/friendlist_page.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:ARMOYU/Widgets/detectabletext.dart';
import 'package:ARMOYU/Widgets/text.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/posts.dart';
import 'package:skeletons/skeletons.dart';

class ProfilePage extends StatefulWidget {
  final int? userID;
  final String? username;
  final bool appbar;

  const ProfilePage({
    super.key,
    this.userID,
    required this.appbar,
    this.username,
  });
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

late TabController tabController;

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

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

  @override
  void initState() {
    super.initState();
    test();

    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TEST.cancel();
    super.dispose();
  }

  List<Widget> widgetPosts = [];
  List<Widget> widgetTaggedPosts = [];
  List<Media> medialist = [];

  profileloadPosts(
      int page, int userID, List<Widget> list, String category) async {
    if (postsfetchproccess) {
      return;
    }
    if (mounted) {
      setState(() {
        postsfetchproccess = true;
      });
    }
    FunctionService f = FunctionService();
    Map<String, dynamic> response =
        await f.getprofilePosts(page, userID, category);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      if (mounted) {
        setState(() {
          postsfetchproccess = false;
        });
      }

      return;
    }

    if (response["icerik"].length == 0) {
      if (mounted) {
        setState(() {
          postsfetchproccess = false;
        });
      }
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Media> media = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

        for (int j = 0; j < mediaItemCount; j++) {
          media.add(
            Media(
              mediaID: response["icerik"][i]["paylasimfoto"][j]["fotoID"],
              ownerID: response["icerik"][i]["sahipID"],
              mediaType: response["icerik"][i]["paylasimfoto"][j]
                  ["paylasimkategori"],
              mediaDirection: response["icerik"][i]["paylasimfoto"][j]
                  ["medyayonu"],
              mediaURL: MediaURL(
                  bigURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotoufakurl"],
                  normalURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotominnakurl"],
                  minURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotominnakurl"]),
            ),
          );
        }
      }
      if (mounted) {
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
        if (mounted) {
          setState(() {
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
            );

            list.add(
              TwitterPostWidget(
                post: post,
              ),
            );
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        postscounter++;
        postsfetchproccess = false;
      });
    }
  }

  gallery(int page, int userID) async {
    if (mounted) {
      setState(() {
        firstgalleryfetcher = true;
      });
    }
    if (galleryproccess) {
      return;
    }
    if (mounted) {
      setState(() {
        galleryproccess = true;
      });
    }

    if (page == 1) {
      if (mounted) {
        setState(() {
          medialist.clear();
        });
      }
    }

    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response = await f.fetch(userID, "-1", page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      log("Sayfa Sonu");
      if (mounted) {
        setState(() {
          galleryproccess = false;
        });
      }
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
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
        });
      }
    }
    if (mounted) {
      setState(() {
        galleryproccess = false;
        gallerycounter++;
      });
    }
  }

  profileloadtaggedPosts(
      int page, int userID, List<Widget> list, String category) async {
    if (postsfetchProccessv2) {
      return;
    }
    if (mounted) {
      setState(() {
        postsfetchProccessv2 = true;
      });
    }
    FunctionService f = FunctionService();
    Map<String, dynamic> response =
        await f.getprofilePosts(page, userID, category);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      if (mounted) {
        setState(() {
          postsfetchProccessv2 = false;
        });
      }
      return;
    }

    if (response["icerik"].length == 0) {
      if (mounted) {
        setState(() {
          postsfetchProccessv2 = false;
        });
      }

      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Media> media = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

        for (int j = 0; j < mediaItemCount; j++) {
          media.add(
            Media(
              mediaID: response["icerik"][i]["paylasimfoto"][j]["fotoID"],
              ownerID: response["icerik"][i]["sahipID"],
              mediaType: response["icerik"][i]["paylasimfoto"][j]
                  ["paylasimkategori"],
              mediaDirection: response["icerik"][i]["paylasimfoto"][j]
                  ["medyayonu"],
              mediaURL: MediaURL(
                  bigURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotoufakurl"],
                  normalURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotominnakurl"],
                  minURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotominnakurl"]),
            ),
          );
        }
      }
      if (mounted) {
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
        if (mounted) {
          setState(() {
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
            );

            list.add(
              TwitterPostWidget(
                post: post,
              ),
            );
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        postscounterv2++;
        postsfetchProccessv2 = false;
      });
    }
  }

  Future<void> test() async {
    if (widget.userID == ARMOYU.Appuser.userID) {
      userProfile = ARMOYU.Appuser;
    } else {
      Map<String, dynamic> response = {};
      if (widget.userID == null && widget.username != null) {
        FunctionService f = FunctionService();
        Map<String, dynamic> response =
            await f.lookProfilewithusername(widget.username!);

        if (response["durum"] == 0) {
          log("Oyuncu bulunamadı");
          return;
        }
        //Kullanıcı adında birisi var
        Map<String, dynamic> oyuncubilgi = response["icerik"];

        userProfile.userID = oyuncubilgi["oyuncuID"];
        userProfile.userName = oyuncubilgi["kullaniciadi"];
        userProfile.displayName = oyuncubilgi["adim"];
        userProfile.banner = Media(
          mediaID: oyuncubilgi["parkaresimID"],
          mediaURL: MediaURL(
            bigURL: oyuncubilgi["parkaresimminnak"],
            normalURL: oyuncubilgi["parkaresimminnak"],
            minURL: oyuncubilgi["parkaresimminnak"],
          ),
        );
        userProfile.avatar = Media(
          mediaID: oyuncubilgi["presimID"],
          mediaURL: MediaURL(
            bigURL: oyuncubilgi["presimminnak"],
            normalURL: oyuncubilgi["presimminnak"],
            minURL: oyuncubilgi["presimminnak"],
          ),
        );

        userProfile.level = oyuncubilgi["seviye"];
        userProfile.levelColor = oyuncubilgi["seviyerenk"];
        userProfile.xp = oyuncubilgi["seviyexp"];
        userProfile.friendsCount = oyuncubilgi["arkadaslar"];
        userProfile.postsCount = oyuncubilgi["gonderiler"];
        userProfile.awardsCount = oyuncubilgi["oduller"];

        userProfile.country = oyuncubilgi["ulkesi"];
        userProfile.province = oyuncubilgi["ili"];
        userProfile.registerDate = oyuncubilgi["kayittarihikisa"];

        userProfile.burc = oyuncubilgi["burc"];

        if (oyuncubilgi["favoritakim"] != null) {
          userProfile.favTeam = Team(
            teamID: oyuncubilgi["favoritakim"]["takim_ID"],
            name: oyuncubilgi["favoritakim"]["takim_adi"],
            logo: oyuncubilgi["favoritakim"]["takim_logo"],
          );
        }

        userProfile.job = oyuncubilgi["isyeriadi"];

        userProfile.role = oyuncubilgi["yetkisiacikla"];
        userProfile.rolecolor = oyuncubilgi["yetkirenk"];
        userProfile.aboutme = oyuncubilgi["hakkimda"];

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
        for (int i = 0; i < oyuncubilgi["ortakarkadasliste"].length; i++) {
          if (mounted) {
            setState(() {
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
              listFriendTOP3.add(
                  oyuncubilgi["ortakarkadasliste"][i]["oyuncuminnakavatar"]);
            });
          }
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
        FunctionService f = FunctionService();
        response = await f.lookProfile(widget.userID!);
        if (response["durum"] == 0) {
          log("Oyuncu bulunamadı");
          return;
        }

        Map<String, dynamic> oyuncubilgi = response["icerik"];

        userProfile.userID = oyuncubilgi["oyuncuID"];
        userProfile.userName = oyuncubilgi["kullaniciadi"];
        userProfile.displayName = oyuncubilgi["adim"];
        userProfile.banner = Media(
          mediaID: oyuncubilgi["parkaresimID"],
          mediaURL: MediaURL(
            bigURL: oyuncubilgi["parkaresimminnak"],
            normalURL: oyuncubilgi["parkaresimminnak"],
            minURL: oyuncubilgi["parkaresimminnak"],
          ),
        );
        userProfile.avatar = Media(
          mediaID: oyuncubilgi["presimID"],
          mediaURL: MediaURL(
            bigURL: oyuncubilgi["presimminnak"],
            normalURL: oyuncubilgi["presimminnak"],
            minURL: oyuncubilgi["presimminnak"],
          ),
        );

        userProfile.level = oyuncubilgi["seviye"];
        userProfile.levelColor = oyuncubilgi["seviyerenk"];

        userProfile.xp = oyuncubilgi["seviyexp"];

        userProfile.friendsCount = oyuncubilgi["arkadaslar"];
        userProfile.postsCount = oyuncubilgi["gonderiler"];
        userProfile.awardsCount = oyuncubilgi["oduller"];

        userProfile.country = oyuncubilgi["ulkesi"];
        userProfile.province = oyuncubilgi["ili"];
        userProfile.registerDate = oyuncubilgi["kayittarihikisa"];

        userProfile.burc = oyuncubilgi["burc"];

        if (oyuncubilgi["favoritakim"] != null) {
          userProfile.favTeam = Team(
            teamID: oyuncubilgi["favoritakim"]["takim_ID"],
            name: oyuncubilgi["favoritakim"]["takim_adi"],
            logo: oyuncubilgi["favoritakim"]["takim_logo"],
          );
        }

        userProfile.job = oyuncubilgi["isyeriadi"];

        userProfile.role = oyuncubilgi["yetkisiacikla"];
        userProfile.rolecolor = oyuncubilgi["yetkirenk"];
        userProfile.aboutme = oyuncubilgi["hakkimda"];

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
        for (int i = 0; i < oyuncubilgi["ortakarkadasliste"].length; i++) {
          if (mounted) {
            setState(() {
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
              listFriendTOP3.add(
                  oyuncubilgi["ortakarkadasliste"][i]["oyuncuminnakavatar"]);
            });
          }
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

      if (isbeFriend &&
          !isFriend &&
          userProfile.userID != ARMOYU.Appuser.userID) {
        friendStatus = "Arkadaş Ol";
        friendStatuscolor = Colors.blue;
      } else if (!isbeFriend &&
          !isFriend &&
          userProfile.userID != ARMOYU.Appuser.userID &&
          userProfile.userID != -1) {
        friendStatus = "İstek Gönderildi";
        friendStatuscolor = Colors.black;
      } else if (!isbeFriend &&
          isFriend &&
          userProfile.userID != ARMOYU.Appuser.userID) {
        friendStatus = "Mesaj Gönder";
        friendStatuscolor = Colors.blue;
      }
    }

    if (firstFetchPosts) {
      await profileloadPosts(
          postscounter, userProfile.userID!, widgetPosts, "");
      if (mounted) {
        setState(() {
          firstFetchPosts = false;
        });
      }
    }
    if (firstFetchGallery) {
      await gallery(gallerycounter, userProfile.userID!);

      if (mounted) {
        setState(() {
          firstFetchGallery = false;
        });
      }
    }

    if (firstFetchTaggedPost) {
      await profileloadtaggedPosts(postscounterv2, userProfile.userID!,
          widgetTaggedPosts, "etiketlenmis");
      if (mounted) {
        setState(() {
          firstFetchTaggedPost = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await test();
  }

  Future<void> changeavatar() async {
    XFile? selectedImage = await AppCore.pickImage();
    if (selectedImage == null) {
      return;
    }
    FunctionsProfile f = FunctionsProfile();
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);
    Map<String, dynamic> response = await f.changeavatar(imagePath);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (mounted) {
      setState(() {
        ARMOYU.Appuser.avatar = Media(
          mediaID: 1000000,
          mediaURL: MediaURL(
            bigURL: response["aciklamadetay"].toString(),
            normalURL: response["aciklamadetay"].toString(),
            minURL: response["aciklamadetay"].toString(),
          ),
        );

        _handleRefresh();
      });
    }
  }

  Future<void> changebanner() async {
    XFile? selectedImage = await AppCore.pickImage();
    if (selectedImage == null) {
      return;
    }
    FunctionsProfile f = FunctionsProfile();
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);
    Map<String, dynamic> response = await f.changebanner(imagePath);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (mounted) {
      setState(() {
        ARMOYU.Appuser.banner = Media(
          mediaID: 1000000,
          mediaURL: MediaURL(
            bigURL: response["aciklamadetay"].toString(),
            normalURL: response["aciklamadetay"].toString(),
            minURL: response["aciklamadetay"].toString(),
          ),
        );
        _handleRefresh();
      });
    }
  }

  Future<void> friendrequest() async {
    FunctionsProfile f = FunctionsProfile();
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
            width: 30,
            height: 30,
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
          width: 30,
          height: 30,
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
      backgroundColor: ARMOYU.bodyColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned:
                  ARMOYU.Appuser.userID != userProfile.userID ? true : false,
              backgroundColor: Colors.black,
              expandedHeight: ARMOYU.screenHeight * 0.25,
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
                                        InkWell(
                                          onTap: () {},
                                          child: const ListTile(
                                            leading: Icon(Icons.share_outlined),
                                            title: Text("Profili paylaş."),
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
                                        const Visibility(
                                          //Çizgi ekler
                                          child: Divider(),
                                        ),
                                        Visibility(
                                          visible: userProfile.userID !=
                                              ARMOYU.Appuser.userID,
                                          child: InkWell(
                                            onTap: () async {
                                              FunctionsBlocking f =
                                                  FunctionsBlocking();
                                              Map<String, dynamic> response =
                                                  await f
                                                      .add(userProfile.userID!);
                                              if (response["durum"] == 0) {
                                                log(response["aciklama"]);
                                                return;
                                              }
                                              try {
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                }
                                              } catch (e) {
                                                log(e.toString());
                                              }
                                            },
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
                                          visible: userProfile.userID !=
                                              ARMOYU.Appuser.userID,
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
                                                  FunctionsProfile();
                                              Map<String, dynamic> response =
                                                  await f.friendremove(
                                                      widget.userID!);
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
                                                  FunctionsProfile();
                                              Map<String, dynamic> response =
                                                  await f.userdurting(
                                                      widget.userID!);
                                              if (response["durum"] == 0) {
                                                log(response["aciklama"]);
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MediaViewer(
                          media: [userProfile.banner!],
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    if (ARMOYU.Appuser.userID != userProfile.userID) {
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
                                    visible: ARMOYU.Appuser.userID ==
                                        userProfile.userID,
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
                                  const Visibility(
                                    //Çizgi ekler
                                    child: Divider(),
                                  ),
                                  Visibility(
                                    visible: userProfile.userID ==
                                        ARMOYU.Appuser.userID,
                                    child: InkWell(
                                      onTap: () {},
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
                      : CachedNetworkImage(
                          imageUrl: userProfile.banner!.mediaURL.minURL,
                          fit: BoxFit.cover,
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MediaViewer(
                                      media: [userProfile.avatar!],
                                      initialIndex: 0,
                                    ),
                                  ));
                                },
                                onLongPress: () {
                                  if (ARMOYU.Appuser.userID !=
                                      userProfile.userID) {
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
                                                  visible:
                                                      ARMOYU.Appuser.userID ==
                                                          userProfile.userID,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await changeavatar();
                                                    },
                                                    child: const ListTile(
                                                      leading: Icon(
                                                          Icons.camera_alt),
                                                      title: Text(
                                                          "Avatar değiştir."),
                                                    ),
                                                  ),
                                                ),
                                                const Visibility(
                                                  //Çizgi ekler
                                                  child: Divider(),
                                                ),
                                                Visibility(
                                                  visible: userProfile.userID ==
                                                      ARMOYU.Appuser.userID,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: const ListTile(
                                                      textColor: Colors.red,
                                                      leading: Icon(
                                                        Icons
                                                            .person_off_outlined,
                                                        color: Colors.red,
                                                      ),
                                                      title: Text(
                                                          "Varsayılana dönder."),
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
                                          width: 80,
                                          height: 80,
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
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    userProfile.avatar!.mediaURL
                                                        .minURL,
                                                  ),
                                                ),
                                              ),
                                              child: Align(
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
                                                        const BorderRadius.all(
                                                      Radius.elliptical(
                                                        100,
                                                        100,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      userProfile.level
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                                                  username:
                                                      userProfile.userName!,
                                                  userid: userProfile.userID!,
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
                                                        "Arkadaş"),
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
                                                  if (userProfile.userID !=
                                                      ARMOYU.Appuser.userID) {
                                                    return;
                                                  }

                                                  setState(() {
                                                    ARMOYUFunctions
                                                        .selectFavTeam(context,
                                                            force: true);
                                                  });
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
                                userProfile.role!,
                                style: TextStyle(
                                  color: Color(
                                    int.parse("0xFF${userProfile.rolecolor}"),
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
                              : CustomText.costum1(
                                  "${userProfile.country}, ${userProfile.province}",
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
                              : CustomText.costum1(userProfile.job!),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ARMOYU.Appuser.userID != userProfile.userID &&
                          listFriendTOP3.isNotEmpty,
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
                                    context, friendTextLine)
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
                          visible: isbeFriend &&
                              !isFriend &&
                              userProfile.userID != ARMOYU.Appuser.userID,
                          child: Expanded(
                            child: CustomButtons.friendbuttons(
                                friendStatus, friendrequest, friendStatuscolor),
                          ),
                        ),
                        Visibility(
                          //İstek Gönderildi
                          visible: !isbeFriend &&
                              !isFriend &&
                              userProfile.userID != ARMOYU.Appuser.userID &&
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
                                          borderRadius: BorderRadius.circular(
                                              8), // Kenar yarıçapını ayarlayın
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
                                      friendStatuscolor),
                                ),
                        ),
                        Visibility(
                          //Mesaj Gönder
                          visible: !isbeFriend &&
                              isFriend &&
                              userProfile.userID != ARMOYU.Appuser.userID,
                          child: Expanded(
                            child:
                                Chat(user: userProfile, chatNotification: false)
                                    .profilesendMessage(context),
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
              delegate: Profileusersharedmedias(),
            )
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            firstFetchPosts
                ? const Center(child: CupertinoActivityIndicator())
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
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const ClampingScrollPhysics(),
                                key: const PageStorageKey('Tab1'),
                                itemCount: widgetPosts.length,
                                itemBuilder: (context, index) {
                                  return widgetPosts[index];
                                },
                              ),
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
                        child: Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                physics: const ClampingScrollPhysics(),
                                key: const PageStorageKey('Tab2'),
                                itemCount: medialist.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4.0, // Yatayda boşluk
                                  mainAxisSpacing: 4.0, // Dikeyde boşluk
                                ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MediaViewer(
                                            media: medialist,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          medialist[index].mediaURL.minURL,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: galleryproccess,
                              child: Container(
                                height: 100,
                                width: ARMOYU.screenWidth,
                                color: ARMOYU.backgroundcolor,
                                child: const CupertinoActivityIndicator(),
                              ),
                            ),
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
                                  "etiketlenmis");

                              return true;
                            }
                          }
                          return false;
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey('Tab3'),
                          itemCount: widgetTaggedPosts.length,
                          itemBuilder: (context, index) {
                            return widgetTaggedPosts[index];
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

class Profileusersharedmedias extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.center,
      color: ARMOYU.bodyColor,
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
