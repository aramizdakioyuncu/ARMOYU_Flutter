// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/AppCore.dart';

import 'package:ARMOYU/Screens/Chat/chatdetail_page.dart';
import 'package:ARMOYU/Screens/Profile/friendlist_page.dart';
import 'package:ARMOYU/Screens/Utility/FullScreenImagePage.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/Utility.dart';
import 'package:ARMOYU/Widgets/detectabletext.dart';
import 'package:ARMOYU/Widgets/text.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/posts.dart';

class ProfilePage extends StatefulWidget {
  int? userID; // Zorunlu olarak alınacak veri
  final String? username; // Zorunlu olmayan  veri
  final bool appbar; // Zorunlu olarak alınacak veri

  ProfilePage({
    this.userID,
    required this.appbar,
    this.username,
  });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

late TabController tabController;

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  int userID = -1;

  String userName = "...";
  String displayName = "...";
  String banneravatar =
      "https://upload.wikimedia.org/wikipedia/commons/7/71/Black.png";
  String banneravatarbetter =
      "https://upload.wikimedia.org/wikipedia/commons/7/71/Black.png";
  String avatar =
      "https://aramizdakioyuncu.com/galeri/ana-yapi/gifler/spinner.gif";
  String avatarbetter =
      "https://aramizdakioyuncu.com/galeri/ana-yapi/gifler/spinner.gif";

  int level = 0;

  int friendsCount = 0;
  int postsCount = 0;
  int awardsCount = 0;

  String country = "...";
  String province = "";
  String registerdate = "...";
  String job = "";
  String role = "...";
  String rolecolor = "FFFFFF";
  String aboutme = "";
  String burc = "...";

  bool isFriend = false;

  bool isbeFriend = false;

  List<String> listFriendTOP3 = [
    "https://aramizdakioyuncu.com/galeri/ana-yapi/gifler/spinner.gif",
    "https://aramizdakioyuncu.com/galeri/ana-yapi/gifler/spinner.gif",
    "https://aramizdakioyuncu.com/galeri/ana-yapi/gifler/spinner.gif"
  ];
  String friendTextLine = "";

  bool isAppBarExpanded = true;
  late ScrollController pageMainscroller;
  late ScrollController galleryscrollcontroller;
  late ScrollController postsscrollcontroller;
  bool galleryproccess = false;
  bool first_galleryproccess = false;

  String friendStatus = "Bekleniyor";
  Color friendStatuscolor = Colors.blue;

  @override
  void initState() {
    super.initState();
    TEST();

    pageMainscroller = ScrollController();
    pageMainscroller.addListener(() {
      setState(() {
        isAppBarExpanded = pageMainscroller.offset <
            ARMOYU.screenHeight * 0.20; // veya başka bir eşik değeri
      });
    });

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging ||
          tabController.index != tabController.previousIndex) {
        if (tabController.index == 1) {
          if (!first_galleryproccess) {
            gallery();
            first_galleryproccess = true;
          }
        }
      }
    });

    postsscrollcontroller = ScrollController();
    postsscrollcontroller.addListener(() {
      if (postsscrollcontroller.position.pixels ==
          postsscrollcontroller.position.maxScrollExtent) {
        // gallery();
        log("sd");
      }
    });

    galleryscrollcontroller = ScrollController();
    galleryscrollcontroller.addListener(() {
      if (galleryscrollcontroller.position.pixels ==
          galleryscrollcontroller.position.maxScrollExtent) {
        gallery();
      }
    });
  }

  @override
  void dispose() {
    // TEST.cancel();
    super.dispose();
  }

  List<Widget> Widget_Posts = [];
  final List<String> imageUrls = [];
  final List<String> imageufakUrls = [];

  Future<void> loadPostsv2(int page, int Userid) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getprofilePosts(page, Userid);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;
    if (dynamicItemCount > 0) {
      Widget_Posts.clear();
    }
    for (int i = 0; i < dynamicItemCount; i++) {
      List<int> mediaIDs = [];
      List<int> mediaownerIDs = [];
      List<String> medias = [];
      List<String> mediasbetter = [];
      List<String> mediastype = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

        for (int j = 0; j < mediaItemCount; j++) {
          mediaIDs.add(response["icerik"][i]["paylasimfoto"][j]["fotoID"]);
          mediaownerIDs.add(response["icerik"][i]["sahipID"]);
          medias.add(response["icerik"][i]["paylasimfoto"][j]["fotominnakurl"]);
          mediasbetter
              .add(response["icerik"][i]["paylasimfoto"][j]["fotoufakurl"]);
          mediastype.add(
              response["icerik"][i]["paylasimfoto"][j]["paylasimkategori"]);
        }
      }
      if (mounted) {
        setState(() {
          Widget_Posts.add(
            TwitterPostWidget(
              userID: response["icerik"][i]["sahipID"],
              profileImageUrl: response["icerik"][i]["sahipavatarminnak"],
              username: response["icerik"][i]["sahipad"],
              postID: response["icerik"][i]["paylasimID"],
              postText: response["icerik"][i]["paylasimicerik"],
              postDate: response["icerik"][i]["paylasimzamangecen"],
              mediaIDs: mediaIDs,
              mediaownerIDs: mediaownerIDs,
              mediaUrls: medias,
              mediabetterUrls: mediasbetter,
              mediatype: mediastype,
              postlikeCount: response["icerik"][i]["begenisay"],
              postcommentCount: response["icerik"][i]["yorumsay"],
              postMecomment: response["icerik"][i]["benyorumladim"],
              postMelike: response["icerik"][i]["benbegendim"],
              isPostdetail: false,
            ),
          );
        });
      }
    }
  }

  Future<void> TEST() async {
    if (widget.userID == User.ID) {
      userID = User.ID;
      userName = User.userName;
      displayName = User.displayName;
      banneravatar = User.banneravatar;
      banneravatarbetter = User.banneravatarbetter;
      avatar = User.avatar;
      avatarbetter = User.avatarbetter;
      level = User.level;
      friendsCount = User.friendsCount;
      postsCount = User.postsCount;
      awardsCount = User.awardsCount;

      country = User.country;
      province = User.province;
      registerdate = User.registerdate;

      aboutme = User.aboutme;

      burc = User.burc;

      try {
        job = User.job;
      } catch (Ex) {}

      try {
        role = User.role;
      } catch (Ex) {}
      try {
        rolecolor = User.rolecolor;
      } catch (Ex) {}
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

        userID = int.parse(response["oyuncuID"]);
        userName = response["kullaniciadi"];
        displayName = response["adim"];
        banneravatar = response["parkaresimminnak"];
        banneravatarbetter = response["parkaresimufak"];
        avatar = response["presimminnak"];
        avatarbetter = response["presimufak"];

        level = response["seviye"];
        friendsCount = response["arkadaslar"];
        postsCount = response["gonderiler"];
        awardsCount = response["oduller"];

        if (response["ulkesi"] != null) {
          country = response["ulkesi"];
        }
        if (response["ili"] != null) {
          province = response["ili"];
        }
        registerdate = response["kayittarihikisa"];

        if (response["burc"] != null) {
          burc = response["burc"];
        }

        if (response["isyeriadi"] != null) {
          job = response["isyeriadi"];
        }

        if (response["yetkisiacikla"] != null) {
          role = response["yetkisiacikla"];
        }
        if (response["yetkirenk"] != null) {
          rolecolor = response["yetkirenk"];
        }
        if (response["hakkimda"] != null) {
          aboutme = response["hakkimda"];
        }

        if (response["arkadasdurum"] == "1") {
          isFriend = true;
          isbeFriend = false;
        } else if (response["arkadasdurum"] == "2") {
          isFriend = false;
          isbeFriend = false;
        } else {
          isFriend = false;
          isbeFriend = true;
        }
        listFriendTOP3.clear();
        for (int i = 0; i < response["ortakarkadasliste"].length; i++) {
          if (mounted) {
            setState(() {
              if (i < 2) {
                if (i == 0) {
                  friendTextLine += "@" +
                      response["ortakarkadasliste"][i]["oyuncukullaniciadi"] +
                      " ";
                } else {
                  if (response["ortakarkadasliste"].length == 2) {
                    friendTextLine += "ve @" +
                        response["ortakarkadasliste"][i]["oyuncukullaniciadi"];
                  } else {
                    friendTextLine += ", @" +
                        response["ortakarkadasliste"][i]["oyuncukullaniciadi"] +
                        " ";
                  }
                }
              }
              listFriendTOP3
                  .add(response["ortakarkadasliste"][i]["oyuncuminnakavatar"]);
            });
          }
        }

        if (response["ortakarkadasliste"].length > 2) {
          int mutualFriend = response["ortakarkadaslar"] - 2;
          friendTextLine +=
              "ve " + mutualFriend.toString() + " diğer kişi ile arkadaş";
        } else if (response["ortakarkadasliste"].length == 2) {
          friendTextLine += " ile arkadaş";
        } else if (response["ortakarkadasliste"].length == 1) {
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
        userID = int.parse(response["oyuncuID"]);
        userName = response["kullaniciadi"];
        displayName = response["adim"];
        banneravatar = response["parkaresimminnak"];
        banneravatarbetter = response["parkaresimufak"];
        avatar = response["presimminnak"];
        avatarbetter = response["presimufak"];

        level = response["seviye"];
        friendsCount = response["arkadaslar"];
        postsCount = response["gonderiler"];
        awardsCount = response["oduller"];

        if (response["ulkesi"] != null) {
          country = response["ulkesi"];
        }
        if (response["ili"] != null) {
          province = response["ili"];
        }
        registerdate = response["kayittarihikisa"];

        if (response["burc"] != null) {
          burc = response["burc"];
        }

        if (response["isyeriadi"] != null) {
          job = response["isyeriadi"];
        }

        if (response["yetkisiacikla"] != null) {
          role = response["yetkisiacikla"];
        }
        if (response["yetkirenk"] != null) {
          rolecolor = response["yetkirenk"];
        }
        if (response["hakkimda"] != null) {
          aboutme = response["hakkimda"];
        }

        if (response["arkadasdurum"] == "1") {
          isFriend = true;
          isbeFriend = false;
        } else if (response["arkadasdurum"] == "2") {
          isFriend = false;
          isbeFriend = false;
        } else {
          isFriend = false;
          isbeFriend = true;
        }

        listFriendTOP3.clear();
        for (int i = 0; i < response["ortakarkadasliste"].length; i++) {
          if (mounted) {
            setState(() {
              if (i < 2) {
                if (i == 0) {
                  friendTextLine += "@" +
                      response["ortakarkadasliste"][i]["oyuncukullaniciadi"] +
                      " ";
                } else {
                  if (response["ortakarkadasliste"].length == 2) {
                    friendTextLine += "ve @" +
                        response["ortakarkadasliste"][i]["oyuncukullaniciadi"];
                  } else {
                    friendTextLine += ", @" +
                        response["ortakarkadasliste"][i]["oyuncukullaniciadi"] +
                        " ";
                  }
                }
              }
              listFriendTOP3
                  .add(response["ortakarkadasliste"][i]["oyuncuminnakavatar"]);
            });
          }
        }

        if (response["ortakarkadasliste"].length > 2) {
          int mutualFriend = response["ortakarkadaslar"] - 2;
          friendTextLine +=
              "ve " + mutualFriend.toString() + " diğer kişi ile arkadaş";
        } else if (response["ortakarkadasliste"].length == 2) {
          friendTextLine += " ile arkadaş";
        } else if (response["ortakarkadasliste"].length == 1) {
          friendTextLine += " ile arkadaş";
        }
        /////
      }

      if (isbeFriend && !isFriend && userID != User.ID) {
        friendStatus = "Arkadaş Ol";
        friendStatuscolor = Colors.blue;
      } else if (!isbeFriend &&
          !isFriend &&
          userID != User.ID &&
          userID != -1) {
        friendStatus = "İstek Gönderildi";
        friendStatuscolor = Colors.black;
      } else if (!isbeFriend && isFriend && userID != User.ID) {
        friendStatus = "Mesaj Gönder";
        friendStatuscolor = Colors.blue;
      }
    }

    await loadPostsv2(1, userID);
  }

  Future<void> _handleRefresh() async {
    await TEST();
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
    setState(() {
      User.avatar = response["aciklamadetay"].toString();
      User.avatarbetter = response["aciklamadetay"].toString();

      _handleRefresh();
    });
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
    setState(() {
      User.banneravatar = response["aciklamadetay"].toString();
      User.banneravatarbetter = response["aciklamadetay"].toString();

      _handleRefresh();
    });
  }

  Future<void> friendrequest() async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.friendrequest(userID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    friendStatus = "Bekleniyor";
    friendStatuscolor = Colors.black;
  }

  Future<void> sendmessage() async {
    log("Sohbet açılacak");
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatDetailPage(
        appbar: true,
        userID: userID,
        useravatar: avatar,
        userdisplayname: userName,
      ),
    ));
  }

  Future<void> cancelfriendrequest() async {
    print("istek iptal edilecek ");
  }

  int gallerycounter = 0;
  gallery() async {
    if (galleryproccess) {
      galleryproccess = true;
    }

    if (gallerycounter == 0) {
      if (mounted) {
        setState(() {
          imageUrls.clear();
          imageufakUrls.clear();
        });
      }
    }

    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response =
        await f.fetch(userID, "-1", gallerycounter + 1);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          imageUrls.add(response["icerik"][i]["fotominnakurl"]);
          imageufakUrls.add(response["icerik"][i]["fotoufaklikurl"]);
        });
      }
    }
    galleryproccess = false;
    gallerycounter++;
  }

  Widget Widget_friendList(bool isclip, double left, String imageUrl) {
    if (isclip) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: 30,
            height: 30,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
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
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      // extendBodyBehindAppBar: true,
      body: NestedScrollView(
        controller: pageMainscroller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: User.ID != userID ? true : false,
              floating: false,
              backgroundColor: Colors.black,
              expandedHeight: ARMOYU.screenHeight * 0.20,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.more_vert),
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
                                        borderRadius: const BorderRadius.all(
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
                                      title: Text("Profil linkini kopyala."),
                                    ),
                                  ),
                                  Visibility(
                                    //Çizgi ekler
                                    child: const Divider(),
                                  ),
                                  Visibility(
                                    visible: userID != User.ID,
                                    child: InkWell(
                                      onTap: () {},
                                      child: const ListTile(
                                        textColor: Colors.red,
                                        leading: Icon(
                                          Icons.person_off_outlined,
                                          color: Colors.red,
                                        ),
                                        title: Text("Kullanıcıyı Engelle."),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userID != User.ID,
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
                                        FunctionsProfile f = FunctionsProfile();
                                        Map<String, dynamic> response = await f
                                            .friendremove(widget.userID!);
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
                                        title: Text("Arkadaşlıktan Çıkar."),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isFriend,
                                    child: InkWell(
                                      onTap: () async {
                                        FunctionsProfile f = FunctionsProfile();
                                        Map<String, dynamic> response =
                                            await f.userdurting(widget.userID!);
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
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: userID == User.ID
                      ? const SizedBox()
                      : CustomText().Costum1(displayName),
                ),
                background: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenImagePage(
                        images: [banneravatarbetter],
                        initialIndex: 0,
                      ),
                    ));
                  },
                  onLongPress: () {
                    if (User.ID != userID) {
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
                                    visible: User.ID == userID,
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
                                  Visibility(
                                    //Çizgi ekler
                                    child: const Divider(),
                                  ),
                                  Visibility(
                                    visible: userID == User.ID,
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
                  child: CachedNetworkImage(
                    imageUrl: banneravatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                                    builder: (context) => FullScreenImagePage(
                                      images: [avatarbetter],
                                      initialIndex: 0,
                                    ),
                                  ));
                                },
                                onLongPress: () {
                                  if (User.ID != userID) {
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
                                                  visible: User.ID == userID,
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
                                                Visibility(
                                                  //Çizgi ekler
                                                  child: const Divider(),
                                                ),
                                                Visibility(
                                                  visible: userID == User.ID,
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
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: avatar,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Spacer(),
                                    // Column(
                                    //   children: [
                                    //     CustomText()
                                    //         .Costum1(level.toString()),
                                    //      CustomText().Costum1("Seviye"),
                                    //   ],
                                    // ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        CustomText().Costum1(
                                            postsCount.toString(),
                                            weight: FontWeight.bold),
                                        CustomText().Costum1("Gönderi"),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendlistPage(
                                                  username: userName,
                                                  userid: userID,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              CustomText().Costum1(
                                                  friendsCount.toString(),
                                                  weight: FontWeight.bold),
                                              CustomText().Costum1("Arkadaş"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        CustomText().Costum1(
                                            awardsCount.toString(),
                                            weight: FontWeight.bold),
                                        CustomText().Costum1("Ödül"),
                                      ],
                                    ),
                                    Spacer()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText().Costum1(
                      displayName,
                      size: 16,
                      weight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        CustomText().Costum1(
                          "@" + userName,
                        ),
                        SizedBox(width: 5),
                        Text(
                          role,
                          style: TextStyle(
                            color: Color(
                              int.parse("0xFF" + rolecolor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Visibility(
                      visible: registerdate == "..." ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          CustomText().Costum1(
                            registerdate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                        visible: burc == "..." ? false : true,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.window,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 3),
                            CustomText().Costum1(
                              burc,
                            ),
                          ],
                        )),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: country == "..." ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          CustomText().Costum1(
                            country + ", " + province,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Visibility(
                      visible: job == "" ? false : true,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.school,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 3),
                          CustomText().Costum1(job),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: User.ID != userID,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ...List.generate(listFriendTOP3.length, (index) {
                                final reversedIndex =
                                    listFriendTOP3.length - 1 - index;
                                if (reversedIndex == 0) {
                                  return Widget_friendList(
                                    true,
                                    0,
                                    listFriendTOP3[reversedIndex].toString(),
                                  );
                                }
                                return Widget_friendList(
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
                              children: [
                                SizedBox(height: 20),
                                specialText(context, friendTextLine)
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
                          visible: isbeFriend && !isFriend && userID != User.ID,
                          child: Expanded(
                            child: CustomButtons().friendbuttons(
                                friendStatus, friendrequest, friendStatuscolor),
                          ),
                        ),
                        Visibility(
                          //Bekliyor
                          visible: !isbeFriend &&
                              !isFriend &&
                              userID != User.ID &&
                              userID != -1,
                          child: Expanded(
                            child: CustomButtons().friendbuttons(friendStatus,
                                cancelfriendrequest, friendStatuscolor),
                          ),
                        ),
                        Visibility(
                          //Mesaj Gönder
                          visible: !isbeFriend && isFriend && userID != User.ID,
                          child: Expanded(
                            child: CustomButtons().friendbuttons(
                                friendStatus, sendmessage, friendStatuscolor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Visibility(
                      visible: aboutme == "" ? false : true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDedectabletext().Costum1(aboutme, 3, 13),
                          SizedBox(height: 10),
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
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              controller: postsscrollcontroller,
              itemCount: Widget_Posts.length,
              itemBuilder: (context, index) {
                return Widget_Posts[index];
              },
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              controller: galleryscrollcontroller,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Her satırda 2 görsel
                crossAxisSpacing: 8.0, // Yatayda boşluk
                mainAxisSpacing: 8.0, // Dikeyde boşluk
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          images: imageufakUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            ),
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
    // Başlık içeriğini oluşturun
    return Container(
      alignment: Alignment.center,
      color: ARMOYU.appbarColor,
      child: TabBar(
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.white,
        controller: tabController,
        isScrollable: true,
        indicatorColor: Colors.blue,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText().Costum1('Paylaşımlar', size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText().Costum1('Medya', size: 15.0),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 40.0; // Başlığın maksimum yüksekliği

  @override
  double get minExtent => 40.0; // Başlığın minimum yüksekliği

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
