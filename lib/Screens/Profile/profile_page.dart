// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/AppCore.dart';

import 'package:ARMOYU/Screens/Chat/chatdetail_page.dart';
import 'package:ARMOYU/Screens/Utility/FullScreenImagePage.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/detectabletext.dart';

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
  bool isAppBarExpanded = true;
  late ScrollController _scrollControllersliverapp;
  late ScrollController galleryscrollcontroller;
  bool galleryproccess = false;
  bool first_galleryproccess = false;

  String friendStatus = "Bekleniyor";
  Color friendStatuscolor = Colors.blue;

  @override
  void initState() {
    super.initState();
    TEST();

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    // Add a listener to be notified when the index changes
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        if (tabController.index == 1) {
          if (!first_galleryproccess) {
            gallery();
            first_galleryproccess = true;
          }
        }
      }
    });

    _scrollControllersliverapp = ScrollController();
    _scrollControllersliverapp.addListener(() {
      setState(() {
        isAppBarExpanded = _scrollControllersliverapp.offset <
            100; // veya başka bir eşik değeri
      });
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

  Future<void> TEST() async {
    if (widget.userID == User.ID) {
      userID = User.ID;
      userName = User.userName;
      displayName = User.displayName;
      banneravatar = User.banneravatar;
      banneravatarbetter = User.banneravatarbetter;
      avatar = User.avatar;
      avatarbetter = User.avatarbetter;

      country = User.country!;
      province = User.province!;
      registerdate = User.registerdate!;

      aboutme = User.aboutme!;

      burc = User.burc!;

      try {
        job = User.job!;
      } catch (Ex) {}

      try {
        role = User.role!;
      } catch (Ex) {}
      try {
        rolecolor = User.rolecolor!;
      } catch (Ex) {}
    } else {
      Map<String, dynamic> response = {};
      if (widget.userID == null && widget.username != null) {
        FunctionService f = FunctionService();
        Map<String, dynamic> response =
            await f.lookProfilewithusername(widget.username!);

        log(response.toString());
        if (response["durum"] == 0) {
          log("Oyuncu bulunamadı");
          return;
        }
        //Kullanıcı adında birisi var
        log(response["oyuncuID"].toString());

        userID = int.parse(response["oyuncuID"]);
        userName = response["kullaniciadi"];
        displayName = response["adim"];
        banneravatar = response["parkaresimminnak"];
        banneravatarbetter = response["parkaresimufak"];
        avatar = response["presimminnak"];
        avatarbetter = response["presimufak"];

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
        /////
      }

      if (isbeFriend && !isFriend && userID != User.ID) {
        friendStatus = "Arkadaş Ol";
        friendStatuscolor = Colors.blue;
      } else if (!isbeFriend &&
          !isFriend &&
          userID != User.ID &&
          userID != -1) {
        friendStatus = "Bekleniyor";
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

  final List<String> imageUrls = [];
  final List<String> imageufakUrls = [];

  int gallerycounter = 0;
  gallery() async {
    if (galleryproccess) {
      galleryproccess = true;
    }

    if (gallerycounter == 0) {
      setState(() {
        imageUrls.clear();
        imageufakUrls.clear();
      });
    }

    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response =
        await f.fetch(userID, "-1", gallerycounter + 1);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      setState(() {
        imageUrls.add(response["icerik"][i]["fotominnakurl"]);
        imageufakUrls.add(response["icerik"][i]["fotoufaklikurl"]);
      });
    }
    galleryproccess = false;
    gallerycounter++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: CustomScrollView(
          controller: _scrollControllersliverapp,
          slivers: <Widget>[
            SliverAppBar(
              pinned: User.ID != userID ? true : false,
              floating: false,
              backgroundColor: Colors.black,
              expandedHeight: 160.0,
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
                                        }
                                        log(response["aciklama"]);
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
                                        }
                                        log(response["aciklama"]);
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
                  child:
                      isAppBarExpanded ? const SizedBox() : Text(displayName),
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
            // SliverPersistentHeader(
            //   delegate: MyPersistentHeaderDelegate(),
            //   floating: true,
            //   pinned: true,
            // ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImagePage(
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
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[900],
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(30),
                                                          ),
                                                        ),
                                                        width:
                                                            ARMOYU.screenWidth /
                                                                4,
                                                        height: 5,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          User.ID == userID,
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
                                                      visible:
                                                          userID == User.ID,
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
                                        width: 100, // Yuvarlak resmin genişliği
                                        height: 100,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                //Arkadaş ol
                                visible: isbeFriend &&
                                    !isFriend &&
                                    userID != User.ID,
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomButtons().friendbuttons(
                                          friendStatus,
                                          friendrequest,
                                          friendStatuscolor),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                //Bekliyor
                                visible: !isbeFriend &&
                                    !isFriend &&
                                    userID != User.ID &&
                                    userID != -1,
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomButtons().friendbuttons(
                                          friendStatus,
                                          cancelfriendrequest,
                                          friendStatuscolor),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                //Mesaj Gönder
                                visible: !isbeFriend &&
                                    isFriend &&
                                    userID != User.ID,
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomButtons().friendbuttons(
                                          friendStatus,
                                          sendmessage,
                                          friendStatuscolor),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "@" + userName,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
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
                        const SizedBox(height: 5),
                        Visibility(
                            visible: aboutme == "" ? false : true,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomDedectabletext().Costum1(aboutme, 3, 13),
                                SizedBox(height: 10),
                              ],
                            )),
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
                                Text(
                                  burc,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 5),
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
                              Text(
                                registerdate,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                Text(
                                  country + ", " + province,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )),
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
                              Text(
                                job,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      isScrollable: true,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Paylaşımlar',
                              style: TextStyle(fontSize: 15.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text("Medya", style: TextStyle(fontSize: 15.0)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ARMOYU.screenHeight - 300,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        RefreshIndicator(
                          color: Colors.blue,
                          onRefresh: _handleRefresh,
                          child: ListView.builder(
                            // controller: _scrollController,
                            itemCount: Widget_Posts.length,
                            itemBuilder: (context, index) {
                              return Widget_Posts[index];
                            },
                          ),
                        ),
                        GridView.builder(
                          controller: galleryscrollcontroller,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Her satırda 2 görsel
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
                                        builder: (context) =>
                                            FullScreenImagePage(
                                              images: imageufakUrls,
                                              initialIndex: index,
                                            )));
                              },
                              child: CachedNetworkImage(
                                imageUrl: imageUrls[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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

class MyPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Başlık içeriğini oluşturun
    return Container(
      alignment: Alignment.center,
      child: TabBar(
        unselectedLabelColor: Colors.grey,
        controller: tabController,
        isScrollable: true,
        indicatorColor: Colors.blue,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Paylaşımlar', style: TextStyle(fontSize: 15.0)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Medya", style: TextStyle(fontSize: 15.0)),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0; // Başlığın maksimum yüksekliği

  @override
  double get minExtent => 50.0; // Başlığın minimum yüksekliği

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
