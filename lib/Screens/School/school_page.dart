// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SchoolPage extends StatefulWidget {
  int SchoolID; // Zorunlu olarak alınacak veri

  SchoolPage({
    required this.SchoolID,
  });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SchoolPage>
    with AutomaticKeepAliveClientMixin<SchoolPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TEST.cancel();
    super.dispose();
  }

  void schoolinfofetch() {}
  Future<void> _handleRefresh() async {
    // await TEST();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              floating: false,
              backgroundColor: Colors.black,
              expandedHeight: 180.0,
              actions: <Widget>[],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 00.0),
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
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Sivas Cumhuriyet Üniversitesi",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
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
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
