// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPage createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
  final List<Product> products = [
    Product(
        name: 'Ürün 1',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 19.99),
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
  ];
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
            actions: <Widget>[
              // const SizedBox(width: 10),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 30.0),
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
                            padding: EdgeInsets.all(2), // Set padding as needed
                            child: Text(
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
              SizedBox(height: 16.0),
            ]),
          )
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({required this.name, required this.imageUrl, required this.price});
}
