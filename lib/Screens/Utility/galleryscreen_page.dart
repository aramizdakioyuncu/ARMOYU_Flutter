import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryScreen extends StatefulWidget {
  final User currentUser;
  const GalleryScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

final List<Media> _mediaGallery = [];
int _gallerycounter = 0;
bool _ismediaProcces = false;
bool _mediaUploadProcess = false;

bool _pageisactive = false;
late TabController _tabController;
List<Media> _mediaList = [];
final ScrollController _galleryscrollcontroller = ScrollController();

bool _fetchFirstDeviceGalleryStatus = false;
List<AssetEntity> _assets = [];
List<Media> _memorymedia = [];
List<Media> _thumbnailmemorymedia = [];

class _GalleryScreenState extends State<GalleryScreen>
    with
        AutomaticKeepAliveClientMixin<GalleryScreen>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    //Cihaz Galerisini çek
    if (!_fetchFirstDeviceGalleryStatus) {
      _fetchAssets();
    }

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

    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _tabController.previousIndex) {
        if (_tabController.index == 0) {
          setstatefunction();
        }
        if (_tabController.index == 1) {
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

    FunctionsMedia funct = FunctionsMedia(currentUser: widget.currentUser);
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
    FunctionsMedia f = FunctionsMedia(currentUser: widget.currentUser);
    Map<String, dynamic> response =
        await f.fetch(widget.currentUser.userID!, "", _gallerycounter + 1);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _ismediaProcces = false;
      return;
    }

    if (reloadpage) {
      _mediaGallery.clear();
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      Map<String, dynamic> mediaInfo = response["icerik"][i];
      _mediaGallery.add(
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

  void _fetchAssets() async {
    if (_fetchFirstDeviceGalleryStatus) {
      return;
    }
    _fetchFirstDeviceGalleryStatus = true;
    _assets = await PhotoManager.getAssetListRange(
      start: 0,
      end: 300,
    );

    for (AssetEntity element in _assets) {
      // Original
      final bytes = await element.thumbnailDataWithOption(
        const ThumbnailOption(
          size: ThumbnailSize(600, 600),
          quality: 95,
        ),
      );

      //Thumbnail
      final thumbnailbytes = await element.thumbnailDataWithOption(
        const ThumbnailOption(
          size: ThumbnailSize(150, 150),
          quality: 80,
        ),
      );
      _memorymedia.add(
        Media(
          mediaID: element.typeInt,
          mediaBytes: bytes,
          mediaURL: MediaURL(
            bigURL: "bigURL",
            normalURL: "normalURL",
            minURL: "minURL",
          ),
        ),
      );

      _thumbnailmemorymedia.add(
        Media(
          mediaID: element.typeInt,
          mediaBytes: thumbnailbytes,
          mediaURL: MediaURL(
            bigURL: "bigURL",
            normalURL: "normalURL",
            minURL: "minURL",
          ),
        ),
      );
    }
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text('Hikaye Gönder'),
      ),
      body: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            controller: _tabController,
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
              controller: _tabController,
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
                          currentUser: widget.currentUser,
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
                          itemCount: _mediaGallery.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _mediaGallery[index].mediaGallery(
                              context: context,
                              index: index,
                              medialist: _mediaGallery,
                              storyShare: true,
                              setstatefunction: setstatefunction,
                              currentUser: widget.currentUser,
                            );
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
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Her satırda 3 görsel
                    crossAxisSpacing: 5.0, // Yatayda boşluk
                    mainAxisSpacing: 5.0, // Dikeyde boşluk
                  ),
                  itemCount: _thumbnailmemorymedia.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MediaViewer(
                              currentUser: widget.currentUser,
                              isMemory: true,
                              media: _memorymedia,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Image.memory(
                        _thumbnailmemorymedia[index].mediaBytes!,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
