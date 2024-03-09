// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_element, must_call_super, prefer_interpolation_to_compose_strings, unnecessary_overrides

import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Widgets/Skeletons/search_skeleton.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/API_Functions/search.dart';

class SearchPage extends StatefulWidget {
  final bool appbar;
  final TextEditingController searchController;

  SearchPage({required this.appbar, required this.searchController});

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
  // final TextEditingController _searchController = TextEditingController();
  List<Widget> Widget_search = [];
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchTextChanged);

    log(widget.searchController.text);
  }

  // Function to handle changes in the text field
  void _onSearchTextChanged() {
    searchfunction(widget.searchController, widget.searchController.text);
    // You can perform additional actions here based on the changed text
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    widget.searchController.dispose();
    super.dispose();
  }

  Future<void> loadSkeletonpost() async {
    setState(() {
      Widget_search.clear();
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
      Widget_search.add(SkeletonSearch());
    });
  }

  Future<void> searchfunction(
    TextEditingController controller,
    String text,
  ) async {
    if (controller.text == "") {
      setState(() {
        Widget_search.clear();
      });
      return;
    }
    _searchTimer = Timer(Duration(milliseconds: 300), () async {
      loadSkeletonpost();
      log(text + " " + controller.text);

      if (text != controller.text) {
        return;
      }
      FunctionsSearchEngine f = FunctionsSearchEngine();
      Map<String, dynamic> response = await f.searchengine(1, text);
      if (response["durum"] == 0) {
        log(response["aciklama"]);
        return;
      }

      try {
        setState(() {
          Widget_search.clear();
        });
      } catch (e) {
        log(e.toString());
      }

      int dynamicItemCount = response["icerik"].length;
      //Eğer cevap gelene kadar yeni bir şeyler yazmışsa
      if (text != controller.text) {
        return;
      }
      for (int i = 0; i < dynamicItemCount; i++) {
        try {
          setState(() {
            Widget_search.add(
              ListTile(
                leading: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(
                    response["icerik"][i]["avatar"],
                  ),
                  backgroundColor: Colors.black,
                ),
                title: CustomText().costum1(response["icerik"][i]["Value"],
                    weight: FontWeight.bold),
                trailing: response["icerik"][i]["turu"] == "oyuncu"
                    ? Icon(Icons.person)
                    : Icon(Icons.groups),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        userID: response["icerik"][i]["ID"], appbar: true),
                  ));
                },
              ),
            );
          });
        } catch (e) {
          log(e.toString());
        }
      }

      // postsearchprocess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
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
