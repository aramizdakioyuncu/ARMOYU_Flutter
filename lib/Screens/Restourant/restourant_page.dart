import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/station.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/station.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestourantPage extends StatefulWidget {
  final Station cafe;

  const RestourantPage({
    super.key,
    required this.cafe,
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

    FunctionsStation f = FunctionsStation();
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
                mediaURL: MediaURL(
                  bigURL: element["equipment_image"],
                  normalURL: element["equipment_image"],
                  minURL: element["equipment_image"],
                ),
              ),
              banner: Media(
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
    setState(() {
      fetchEquipmentProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        widget.cafe.name,
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
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Her satırda 2 görsel
                          crossAxisSpacing: 5.0, // Yatayda boşluk
                          mainAxisSpacing: 5.0, // Dikeyde boşluk
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ARMOYU
                                        .appbarColor, // ARMOYU.bacgroundcolor yerine Colors.white kullanıldı
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 125,
                                          child: Image.network(
                                            widget.cafe.products[index].logo
                                                .mediaURL.minURL,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 5),
                                          child: Column(
                                            children: [
                                              CustomText.costum1(widget
                                                  .cafe.products[index].name),
                                              CustomText.costum1(
                                                  "${widget.cafe.products[index].price} TL"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: widget.cafe.products.length,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
