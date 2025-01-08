import 'package:ARMOYU/app/modules/School/_main/controllers/school_controller.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SchoolView extends StatelessWidget {
  const SchoolView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchoolController());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.handleRefresh(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              floating: false,
              backgroundColor: Colors.black,
              expandedHeight: ARMOYU.screenHeight * 0.25,
              actions: const <Widget>[],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 00.0),
                centerTitle: false,
                // expandedTitleScale: 1,
                title: Stack(
                  children: [
                    Wrap(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => controller.schoolInfo.value == null
                                        ? Container()
                                        : CachedNetworkImage(
                                            imageUrl: controller
                                                .schoolInfo
                                                .value!
                                                .schoolLogo!
                                                .mediaURL
                                                .minURL
                                                .value,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Obx(
                                      () => controller.schoolInfo.value == null
                                          ? Shimmer.fromColors(
                                              baseColor:
                                                  Get.theme.disabledColor,
                                              highlightColor:
                                                  Get.theme.highlightColor,
                                              child: const SizedBox(width: 30),
                                            )
                                          : Text(
                                              controller
                                                  .schoolInfo.value!.schoolName
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                background: GestureDetector(
                  child: Obx(
                    () => controller.schoolInfo.value == null
                        ? Container()
                        : CachedNetworkImage(
                            imageUrl: controller.schoolInfo.value!.schoolBanner!
                                .mediaURL.minURL.value,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
