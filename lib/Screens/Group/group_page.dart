import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            leading: BackButton(onPressed: () {
              Navigator.pop(context);
            }),
            backgroundColor: Colors.black,
            expandedHeight: 160.0,
            actions: const <Widget>[
              // const SizedBox(width: 10),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 30.0),
              centerTitle: false,
              // expandedTitleScale: 1,
              title: Stack(
                children: [
                  Wrap(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png",
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black26, // Set the background color
                              borderRadius: BorderRadius.circular(
                                  10), // Set the border radius
                              border: Border.all(
                                color: Colors.black26, // Set the border color
                                width: 2, // Set the border width
                              ),
                            ),
                            padding: const EdgeInsets.all(
                                2), // Set padding as needed
                            child: const Text(
                              'YMaradana',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white, // Set the text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              background: GestureDetector(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://aramizdakioyuncu.com/galeri/istasyonlar/maracana-arkaplan.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16.0),
            ]),
          )
        ],
      ),
    );
  }
}
