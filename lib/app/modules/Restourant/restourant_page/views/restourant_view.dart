import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Restourant/restourant_page/controllers/restourant_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RestourantView extends StatelessWidget {
  const RestourantView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RestourantController(),
    );
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchequipmentlist();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              leading: BackButton(onPressed: () {
                Navigator.pop(context);
              }),
              expandedHeight: ARMOYU.screenHeight * 0.25,
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
                                      imageUrl: controller.cafe.value!.logo
                                          .mediaURL.minURL.value,
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
                                        controller.cafe.value!.name,
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
                    imageUrl:
                        controller.cafe.value!.banner.mediaURL.minURL.value,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.fetchEquipmentProcess.value
                  ? const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : controller.cafe.value!.products.isEmpty
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
                              childAspectRatio: 0.6,
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
                                                      eyeShape:
                                                          QrEyeShape.square,
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
                                                    FoodKeys.orderExplain.tr,
                                                    align: TextAlign.left,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: CustomText.costum1(
                                                      "${FoodKeys.foodProduct.tr}: ${controller.cafe.value!.products[index].name}",
                                                      weight: FontWeight.bold,
                                                      size: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: CustomText.costum1(
                                                      "${FoodKeys.foodPrice.tr}: ${controller.cafe.value!.products[index].price}",
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
                                            controller
                                                .cafe
                                                .value!
                                                .products[index]
                                                .logo
                                                .mediaURL
                                                .minURL
                                                .value,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          children: [
                                            CustomText.costum1(
                                              controller.cafe.value!
                                                  .products[index].name,
                                              weight: FontWeight.bold,
                                              size: 24,
                                            ),
                                            const SizedBox(height: 10),
                                            CustomText.costum1(
                                                "${controller.cafe.value!.products[index].price} TL",
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
                              childCount:
                                  controller.cafe.value!.products.length,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "socailshare${controller.currentUser.value!.userID}",
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
