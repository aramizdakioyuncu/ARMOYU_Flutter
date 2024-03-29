import 'dart:developer';
import 'dart:io';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Screens/Story/storypublish_page.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

final List<String> imageUrls = [];
final List<String> imageufakUrls = [];
int gallerycounter = 0;
bool ismediaProcces = false;

bool pageisactive = false;
late TabController tabController;
List<XFile> imagePath = [];

class _GalleryScreenState extends State<GalleryScreen>
    with
        AutomaticKeepAliveClientMixin<GalleryScreen>,
        TickerProviderStateMixin {
  final ScrollController galleryscrollcontroller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    imagePath.clear();

    if (!pageisactive) {
      startingfunction();
      pageisactive = true;
    }

    galleryscrollcontroller.addListener(() {
      if (galleryscrollcontroller.position.pixels ==
          galleryscrollcontroller.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        galleryfetch();
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
          setState(() {});
        }
        if (tabController.index == 1) {
          setState(() {});
        }
      }
    });
  }

  Future<void> startingfunction() async {
    await galleryfetch();
  }

  Future<void> galleryfetch() async {
    if (ismediaProcces) {
      return;
    }

    ismediaProcces = true;
    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response =
        await f.fetch(ARMOYU.Appuser.userID!, "-1", gallerycounter + 1);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ismediaProcces = false;
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
    gallerycounter++;
    ismediaProcces = false;
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
                padding: const EdgeInsets.all(8.0),
                child: CustomText.costum1('ARMOYU Cloud', size: 15.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText.costum1('Telefon', size: 15.0),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              List<XFile> selectedImages =
                                  await AppCore.pickImages();
                              if (selectedImages.isNotEmpty) {
                                setState(() {
                                  imagePath.addAll(selectedImages);
                                });
                              }
                            },
                            child: const Center(
                              child: Icon(Icons.photo_library_rounded),
                            ),
                          ),
                          if (imagePath.isNotEmpty)
                            SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imagePath.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    MediaViewer(
                                                  media: [
                                                    Media(
                                                      mediaID:
                                                          imagePath.hashCode,
                                                      mediaURL: MediaURL(
                                                          bigURL:
                                                              imagePath[index]
                                                                  .path,
                                                          normalURL:
                                                              imagePath[index]
                                                                  .path,
                                                          minURL:
                                                              imagePath[index]
                                                                  .path),
                                                    ),
                                                  ],
                                                  initialIndex: 0,
                                                  isFile: true,
                                                ),
                                              ));
                                            },
                                            child: Image.file(
                                              File(imagePath[index].path),
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Icon(Icons.send)),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    Expanded(
                      child: imageufakUrls.isEmpty
                          ? const Center(
                              child: Text('Galeri Boş'),
                            )
                          : GridView.builder(
                              controller: galleryscrollcontroller,
                              itemCount: imageufakUrls.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoryPublishPage(
                                          imageID: 1,
                                          imageURL: imageUrls[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrls[index],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Her satırda 3 görsel
                                crossAxisSpacing: 5.0, // Yatayda boşluk
                                mainAxisSpacing: 5.0, // Dikeyde boşluk
                              ),
                            ),
                    ),
                  ],
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
