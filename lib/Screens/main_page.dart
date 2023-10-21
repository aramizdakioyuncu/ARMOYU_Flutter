// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:ARMOYU/Screens/login_page.dart';
import 'package:ARMOYU/Screens/profile_page.dart';
import 'package:ARMOYU/services/User.dart';
import 'package:ARMOYU/services/functions_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/posts.dart';
import '../services/barcode_service.dart';
import '../services/theme_service.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';
  @override
  void initState() {
    super.initState();

    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;

    // initState içinde sayfa yüklendiğinde yapılması gereken işlemleri gerçekleştirin
    loadMyGroups();
    loadMySchools();
    loadPosts();
  }

  List<Widget> Widget_myGroups = [];
  List<Widget> Widget_mySchools = [];

  List<Widget> Widget_Posts = [];

  Future<void> loadMyGroups() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.myGroups();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
    }
    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;

    setState(() {
      Widget_myGroups.clear();
      Widget_myGroups.add(
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Icon(
              Icons.add, // İkon türünü burada belirtin
              size: 30, // İkonun boyutunu burada ayarlayabilirsiniz
              color: Colors
                  .blue, // İkonun rengini değiştirmek için burayı kullanabilirsiniz
            ),
          ),
          title: Text("Grup Oluştur"),
          onTap: () {},
        ),
      );
      for (int i = 0; i < dynamicItemCount; i++) {
        Widget_myGroups.add(
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                response["icerik"][i]["grupminnaklogo"],
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(response["icerik"][i]["grupadi"]),
            onTap: () {},
          ),
        );
      }
    });
  }

  Future<void> loadMySchools() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.mySchools();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
    }

    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;
    setState(() {
      Widget_mySchools.clear();
      for (int i = 0; i < dynamicItemCount; i++) {
        Widget_mySchools.add(
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                response["icerik"][i]["okul_minnaklogo"],
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(response["icerik"][i]["okul_adi"]),
            onTap: () {},
          ),
        );
      }
    });
  }

  Future<void> loadPosts() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getPosts();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
    }

    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;
    setState(() {
      Widget_Posts.clear();
      for (int i = 0; i < dynamicItemCount; i++) {
        List<String> medias = [];

        if (response["icerik"][i]["paylasimfoto"].length != 0) {
          int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

          for (int j = 0; j < mediaItemCount; j++) {
            medias
                .add(response["icerik"][i]["paylasimfoto"][j]["fotominnakurl"]);
          }
        }

        Widget_Posts.add(
          TwitterPostWidget(
            profileImageUrl: response["icerik"][i]["sahipavatarminnak"],
            username: response["icerik"][i]["sahipad"],
            postText: response["icerik"][i]["paylasimicerik"],
            postDate: response["icerik"][i]["paylasimzamangecen"],
            mediaUrls: medias,
            postlikeCount: response["icerik"][i]["begenisay"].toString(),
            postcommentCount: response["icerik"][i]["yorumsay"].toString(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.grey, // Arkaplan rengini ayarlayın
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  padding: EdgeInsets.all(12.0), // İç boşluğu belirleyin
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        50.0), // Kenar yarıçapını ayarlayın
                    child: Image.network(
                      useravatar,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(userName),
                accountEmail: Text(userEmail),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(useravatar),
                    radius: 40.0,
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(userbanner),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Visibility(
                visible: "-12" == "-1" ? true : false,
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text("Toplantı"),
                  onTap: () {},
                ),
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text("Haberler"),
                onTap: () {},
              ),
              Visibility(
                visible: Widget_myGroups.length == 0 ? false : true,
                child: ExpansionTile(
                  leading: Icon(Icons.group),
                  title: Text('Gruplarım'),
                  children: Widget_myGroups,
                ),
              ),
              Visibility(
                visible: Widget_mySchools.length == 0 ? false : true,
                child: ExpansionTile(
                  leading: Icon(Icons.school),
                  title: Text('Okullarım'),
                  children: Widget_mySchools,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Ayarlar"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Çıkış Yap'),
                tileColor: Colors
                    .red, // TileColor özelliği ile arka plan rengini ayarlayın
                onTap: () async {
                  FunctionService f = FunctionService();
                  Map<String, dynamic> response = await f.logOut();

                  if (response["durum"] == 0) {
                    log(response["aciklama"]);
                    return;
                  }
                  passwordController.text = "";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              ListTile(
                // Sağ tarafta bir buton
                trailing: IconButton(
                  icon: Icon(Icons.nightlight), // Sağdaki butonun ikonu
                  onPressed: () {
                    themeProvider.toggleTheme(); // Temayı değiştir
                  },
                ),
                // Sol tarafta bir buton
                leading: IconButton(
                  icon: Icon(Icons.qr_code_2_rounded), // Soldaki butonun ikonu
                  onPressed: () async {
                    BarcodeService bc = BarcodeService();
                    String responsew = await bc.scanQR();
                    print(responsew);
                  },
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Column(
                children: Widget_Posts,
                // children:[
                //   TwitterPostWidget(
                //     profileImageUrl: useravatar,
                //     username: 'User1',
                //     postText: 'Sample post text #flutter',
                //     postDate: '2 hours ago',
                //     mediaUrls: [
                //       'https://picsum.photos/200/300',
                //       'https://picsum.photos/200/300',
                //     ],
                //   ),
                //   TwitterPostWidget(
                //     profileImageUrl: useravatar,
                //     username: 'User2',
                //     postText: 'Sample post text #flutter',
                //     postDate: '2 hours ago',
                //     mediaUrls: [
                //       'https://picsum.photos/200/300',
                //       'https://picsum.photos/200/300',
                //     ],
                //   ),
                //   ElevatedButton(
                //     onPressed: () async {
                //       final GalleryService galleryService = GalleryService();
                //       List<XFile> selectedImages =
                //           await galleryService.pickImages();
                //       selectedImages.length;
                //       print("Seçilen resim sayısı:" +
                //           selectedImages.length.toString() +
                //           " Görsel bilgisi:" +
                //           selectedImages[0].name.toString());
                //     },
                //     child: Text('Görsel Seç'),
                //   ),
                // ],
              ),
            ),
          ],
        ));
  }
}
