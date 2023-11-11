// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'package:ARMOYU/Core/screen.dart';
import 'package:ARMOYU/Screens/search_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/detectabletext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Functions/media.dart';
import '../../Functions/profile.dart';
import '../../Services/functions_service.dart';
import '../../Widgets/buttons.dart';
import '../FullScreenImagePage.dart';

class ProfilePage extends StatefulWidget {
  final int userID; // Zorunlu olarak alınacak veri
  final bool appbar; // Zorunlu olarak alınacak veri

  ProfilePage({required this.userID, required this.appbar});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
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

  @override
  void initState() {
    super.initState();
    TEST();
    voidas();
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
      return;
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.lookProfile(widget.userID);
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
    } else {
      isFriend = false;
      isbeFriend = true;
    }
    return;
  }

  Future<void> _handleRefresh() async {
    await TEST();
    voidas();
  }

  Future<void> friendrequest() async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.friendrequest(widget.userID);
    if (response["durum"] == 0) {
      log("Oyuncu bulunamadı");
      return;
    }
  }

  final List<String> imageUrls = [];
  final List<String> imageufakUrls = [];

  voidas() async {
    setState(() {
      imageUrls.clear();
      imageufakUrls.clear();
    });

    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response = await f.fetch(widget.userID, "-1", 1);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar
          ? AppBar(
              title: Text(displayName),
              backgroundColor: Colors.black,
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
                                      width: Screen.screenWidth / 4,
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
                                        Map<String, dynamic> response =
                                            await f.userdurting(widget.userID);
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
            )
          : null, // Set the AppBar to null if it should be hidden

      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black, // Container'ın arka plan rengi
                height: 160, // Container'ın yüksekliği
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                            images: [banneravatarbetter],
                            initialIndex: 0,
                          ),
                        ));
                      },
                      child: CachedNetworkImage(
                        imageUrl: banneravatar,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    )
                  ],
                ),
              ),
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(
                                      images: [avatarbetter],
                                      initialIndex: 0,
                                    ),
                                  ));
                                },
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        avatar, // Yuvarlak görüntülenmesini istediğiniz resmin URL'si
                                    width: 100, // Yuvarlak resmin genişliği
                                    height: 100, // Yuvarlak resmin yüksekliği
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: isbeFriend,
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomButtons()
                                      .Costum1("Arkadaş Ol", friendrequest),
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
                    // Container(
                    //   height: 300,
                    //   //Maksat boşluk olsun yenilensin
                    // )
                    Container(
                      height: 400,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                      builder: (context) => FullScreenImagePage(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
