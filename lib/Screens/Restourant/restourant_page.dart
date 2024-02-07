// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestourantPage extends StatelessWidget {
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
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
    Product(
        name: 'Ürün 2',
        imageUrl:
            'https://image.milimaj.com/i/milliyet/75/0x410/5c8dcd3845d2a09e009fb6c3.jpg',
        price: 29.99),
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
            // actions: <Widget>[],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 00.0),
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
                                        "https://aramizdakioyuncu.com/galeri/images/1orijinal11700864001.png",
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Blackjack F'B Coffee",
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
                      "https://images.deliveryhero.io/image/fd-tr/LH/u9xe-hero.jpg?width=560&height=300&quality=100",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                "https://images.deliveryhero.io/image/fd-tr/LH/u9xe-hero.jpg?width=560&height=300&quality=100",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 5),
                              child: Column(
                                children: [
                                  CustomText().Costum1("Latte Macchiato"),
                                  CustomText().Costum1("100TL"),
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
              childCount: products.length,
            ),
          ),
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
