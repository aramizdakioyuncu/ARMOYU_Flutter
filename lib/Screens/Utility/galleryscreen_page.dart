import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

final List<Media> mediaGallery = [];
int _gallerycounter = 0;
bool _ismediaProcces = false;
bool _mediaUploadProcess = false;

bool _pageisactive = false;
late TabController tabController;
List<Media> _mediaList = [];
final ScrollController _galleryscrollcontroller = ScrollController();

class _GalleryScreenState extends State<GalleryScreen>
    with
        AutomaticKeepAliveClientMixin<GalleryScreen>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (!_pageisactive) {
      startingfunction();
      _pageisactive = true;
    }

    _galleryscrollcontroller.addListener(() {
      if (_galleryscrollcontroller.position.pixels ==
          _galleryscrollcontroller.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        galleryfetch();
        log("dsa");
      }
    });

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging ||
          tabController.index != tabController.previousIndex) {
        if (tabController.index == 0) {
          setstatefunction();
        }
        if (tabController.index == 1) {
          setstatefunction();
        }
      }
    });
  }

  setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> uploadmediafunction() async {
    if (_mediaUploadProcess) {
      return;
    }

    _mediaUploadProcess = true;
    setstatefunction();

    FunctionsMedia funct = FunctionsMedia();
    Map<String, dynamic> response = await funct.upload(
      files: _mediaList,
      category: "-1",
    );

    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      _mediaUploadProcess = false;
      setstatefunction();
      return;
    }

    _mediaUploadProcess = false;

    _mediaList.clear();
    setstatefunction();
    galleryfetch(reloadpage: true);
  }

  Future<void> startingfunction() async {
    await galleryfetch();
  }

  Future<void> galleryfetch({bool reloadpage = false}) async {
    if (_ismediaProcces) {
      return;
    }

    if (reloadpage) {
      _gallerycounter = 0;
    }
    _ismediaProcces = true;
    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response =
        await f.fetch(ARMOYU.appUser.userID!, "", _gallerycounter + 1);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _ismediaProcces = false;
      return;
    }

    if (reloadpage) {
      mediaGallery.clear();
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      Map<String, dynamic> mediaInfo = response["icerik"][i];
      mediaGallery.add(
        Media(
          mediaID: mediaInfo["media_ID"],
          ownerID: mediaInfo["media_ownerID"],
          mediaType: mediaInfo["fotodosyatipi"],
          mediaTime: mediaInfo["media_time"],
          mediaURL: MediaURL(
            bigURL: mediaInfo["fotoorijinalurl"],
            normalURL: mediaInfo["fotoufaklikurl"],
            minURL: mediaInfo["fotominnakurl"],
          ),
        ),
      );
    }
    _gallerycounter++;
    _ismediaProcces = false;
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text('Hikaye Gönder'),
      ),
      body: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            controller: tabController,
            isScrollable: false,
            indicatorColor: Colors.blue,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: CustomText.costum1('ARMOYU Cloud', size: 15.0),
              ),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: CustomText.costum1('Telefon', size: 15.0),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () async => galleryfetch(reloadpage: true),
                  child: SingleChildScrollView(
                    controller: _galleryscrollcontroller,
                    child: Column(
                      children: [
                        Media.mediaList(
                          _mediaList,
                          setstatefunction,
                          big: false,
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: CustomButtons.costum1(
                                  text: "Yükle",
                                  enabled: _mediaList.isNotEmpty,
                                  onPressed: () async =>
                                      await uploadmediafunction(),
                                  loadingStatus: _mediaUploadProcess,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          controller: ScrollController(),
                          itemCount: mediaGallery.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return mediaGallery[index].mediaGallery(
                                context: context,
                                index: index,
                                medialist: mediaGallery,
                                storyShare: true,
                                setstatefunction: setstatefunction);
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Her satırda 3 görsel
                            crossAxisSpacing: 5.0, // Yatayda boşluk
                            mainAxisSpacing: 5.0, // Dikeyde boşluk
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Text("data"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
