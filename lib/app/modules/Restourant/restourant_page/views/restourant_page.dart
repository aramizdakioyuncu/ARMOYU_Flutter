import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/station.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RestourantPage extends StatefulWidget {
  final Station cafe;
  final User currentUser;

  const RestourantPage({
    super.key,
    required this.cafe,
    required this.currentUser,
  });
  @override
  State<RestourantPage> createState() => _RestourantPage();
}

class _RestourantPage extends State<RestourantPage>
    with AutomaticKeepAliveClientMixin<RestourantPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.cafe.products.isEmpty) {
      fetchequipmentlist();
    }
  }

  bool fetchEquipmentProcess = false;
  Future<void> fetchequipmentlist() async {
    if (fetchEquipmentProcess) {
      return;
    }
    fetchEquipmentProcess = true;

    FunctionsStation f = FunctionsStation(currentUser: widget.currentUser);
    Map<String, dynamic> response =
        await f.fetchEquipments(widget.cafe.stationID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      if (mounted) {
        setState(() {
          fetchEquipmentProcess = false;
        });
      }
      return;
    }

    widget.cafe.products.clear();
    for (var element in response["icerik"]) {
      if (mounted) {
        setState(() {
          widget.cafe.products.add(
            StationEquipment(
              productsID: element["equipment_ID"],
              name: element["equipment_name"],
              logo: Media(
                mediaID: element["equipment_ID"],
                mediaURL: MediaURL(
                  bigURL: element["equipment_image"],
                  normalURL: element["equipment_image"],
                  minURL: element["equipment_image"],
                ),
              ),
              banner: Media(
                mediaID: element["equipment_ID"],
                mediaURL: MediaURL(
                  bigURL: element["equipment_image"],
                  normalURL: element["equipment_image"],
                  minURL: element["equipment_image"],
                ),
              ),
              price: element["equipment_price"],
            ),
          );
        });
      }
    }

    fetchEquipmentProcess = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchequipmentlist();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              leading: BackButton(onPressed: () {
                Navigator.pop(context);
              }),
              backgroundColor: Colors.black,
              expandedHeight: ARMOYU.screenHeight * 0.25,
              // actions: <Widget>[],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 00.0),
                centerTitle: false,
                // expandedTitleScale: 1,
                title: Stack(
                  children: [
                    Wrap(
                      children: [
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          widget.cafe.logo.mediaURL.minURL,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        widget.cafe.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                background: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: widget.cafe.banner.mediaURL.minURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            fetchEquipmentProcess
                ? const SliverToBoxAdapter(
                    child: SizedBox(
                        height: 100, child: CupertinoActivityIndicator()),
                  )
                : widget.cafe.products.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Text("Boş"),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(10.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Her satırda 2 görsel
                            crossAxisSpacing: 5.0, // Yatayda boşluk
                            mainAxisSpacing: 5.0, // Dikeyde boşluk
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  void showQRCodePopup(BuildContext context) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: SizedBox(
                                            height: 400,
                                            width: 200,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                QrImageView(
                                                  data:
                                                      'https://aramizdakioyuncu.com/',
                                                  version: QrVersions.auto,
                                                  size: 200,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  eyeStyle: const QrEyeStyle(
                                                    eyeShape: QrEyeShape.square,
                                                    color: Colors.white,
                                                  ),
                                                  dataModuleStyle:
                                                      const QrDataModuleStyle(
                                                    dataModuleShape:
                                                        QrDataModuleShape
                                                            .square,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                CustomText.costum1(
                                                  "Sipariş vermek için kasaya okutunuz",
                                                  align: TextAlign.left,
                                                  size: 18,
                                                ),
                                                const SizedBox(height: 20),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: CustomText.costum1(
                                                    "Ürün: ${widget.cafe.products[index].name}",
                                                    weight: FontWeight.bold,
                                                    size: 16,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: CustomText.costum1(
                                                    "Fiyat: ${widget.cafe.products[index].price}",
                                                    weight: FontWeight.bold,
                                                    size: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Kapat'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  showQRCodePopup(context);
                                },
                                child: Container(
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color: ARMOYU.bodyColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 180,
                                        width: double.maxFinite,
                                        child: Image.network(
                                          widget.cafe.products[index].logo
                                              .mediaURL.minURL,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        children: [
                                          CustomText.costum1(
                                            widget.cafe.products[index].name,
                                            weight: FontWeight.bold,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomText.costum1(
                                              "${widget.cafe.products[index].price} TL",
                                              weight: FontWeight.bold,
                                              color: Colors.orange,
                                              size: 20,
                                              align: TextAlign.left),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: widget.cafe.products.length,
                          ),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "socailshare${widget.currentUser.userID}",
        onPressed: () {},
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
