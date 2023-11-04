// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_element

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../Services/functions_service.dart';
import '../Widgets/search-engine.dart';

class SearchPage extends StatefulWidget {
  final bool appbar;

  SearchPage({required this.appbar});

  @override
  _SearchPagePage createState() => _SearchPagePage();
}

bool postsearchprocess = false;
Timer? _searchTimer;

class _SearchPagePage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Widget> Widget_search = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> searchfunction(
    TextEditingController controller,
    String text,
  ) async {
    if (text == controller.text && controller.text == "") {
      Widget_search.clear();
      return;
    }
    _searchTimer = Timer(Duration(milliseconds: 300), () async {
      log(text + " " + controller.text);
      // if (controller.text.length <= 3) {
      //   return;
      // }

      if (text != controller.text) {
        return;
      }
      FunctionService f = FunctionService();
      Map<String, dynamic> response = await f.searchengine(1, text);
      if (response["durum"] == 0) {
        log(response["aciklama"]);
        return;
      }

      try {
        setState(() {
          Widget_search.clear();
        });
      } catch (e) {}

      int dynamicItemCount = response["icerik"].length;
      //Eğer cevap gelene kadar yeni bir şeyler yazmışsa
      if (text != controller.text) {
        return;
      }
      for (int i = 0; i < dynamicItemCount; i++) {
        try {
          setState(() {
            Widget_search.add(CustomSearchEngine().costom1(
              context,
              response["icerik"][i]["ID"],
              response["icerik"][i]["adsoyad"],
              response["icerik"][i]["avatar"],
              response["icerik"][i]["turu"],
            ));
          });
        } catch (e) {}
      }

      // postsearchprocess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: widget.appbar
          ? AppBar(
              title: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius:
                      BorderRadius.circular(10.0), // Köşe yuvarlama eklemek
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    hintText: 'Ara',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (text) {
                    // Her metin değişikliğinde fonksiyonu çağırın
                    searchfunction(_searchController, text);
                  },
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : null,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: Widget_search.length,
        itemBuilder: (context, index) {
          return Widget_search[index];
        },
      ),
    );
  }
}
