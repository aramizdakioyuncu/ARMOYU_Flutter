// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'dart:developer';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

final List<String> imageUrls = [];
final List<String> imageufakUrls = [];
int gallerycounter = 0;
bool ismediaProcces = false;

bool pageisactive = false;

class _GalleryScreenState extends State<GalleryScreen>
    with AutomaticKeepAliveClientMixin<GalleryScreen> {
  final ScrollController galleryscrollcontroller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
  }

  Future<void> startingfunction() async {
    await galleryfetch();
    await galleryfetch();
  }

  Future<void> galleryfetch() async {
    if (ismediaProcces) {
      return;
    }

    ismediaProcces = true;
    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response =
        await f.fetch(User.ID, "-1", gallerycounter + 1);

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
        title: Text('Hikaye Gönder'),
      ),
      body: Column(
        children: [
          Expanded(
            child: imageufakUrls.isEmpty
                ? Center(
                    child: Text('Galeri Boş'),
                  )
                : GridView.builder(
                    controller: galleryscrollcontroller,
                    itemCount: imageufakUrls.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Her satırda 3 görsel
                      crossAxisSpacing: 5.0, // Yatayda boşluk
                      mainAxisSpacing: 5.0, // Dikeyde boşluk
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
