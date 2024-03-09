import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SchoolPage extends StatefulWidget {
  final int schoolID; // Zorunlu olarak alınacak veri

  const SchoolPage({
    super.key,
    required this.schoolID,
  });
  @override
  State<SchoolPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SchoolPage>
    with AutomaticKeepAliveClientMixin<SchoolPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  void schoolinfofetch() {}
  Future<void> _handleRefresh() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
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
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://aramizdakioyuncu.com/galeri/okulresimleri/15okullogoorijinal1665778653.png",
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "Sivas Cumhuriyet Üniversitesi",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
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
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://aramizdakioyuncu.com/galeri/okulresimleri/15okularkaresim1665778768.jpg",
                    fit: BoxFit.cover,
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
