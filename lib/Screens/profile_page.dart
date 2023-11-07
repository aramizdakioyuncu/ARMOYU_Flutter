// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'package:ARMOYU/Core/screen.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/detectabletext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Services/functions_service.dart';
import 'FullScreenImagePage.dart';

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

  @override
  void initState() {
    super.initState();
    TEST();
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
    } else {
      isFriend = false;
    }
    return;
  }

  Future<void> _handleRefresh() async {
    await TEST();
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
                                        FunctionService f = FunctionService();
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
                    Row(
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
                    Container(
                      height: 300,
                      //Maksat boşluk olsun yenilensin
                    )
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
