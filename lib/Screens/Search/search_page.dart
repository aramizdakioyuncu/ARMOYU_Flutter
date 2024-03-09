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

  const SearchPage({
    super.key,
    required this.appbar,
    required this.searchController,
  });

  @override
  State<SearchPage> createState() => _SearchPagePage();
}

bool postsearchprocess = false;
Timer? searchTimer;

class _SearchPagePage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  // final TextEditingController _searchController = TextEditingController();
  List<Widget> widgetSearch = [];
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
      widgetSearch.clear();
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
      widgetSearch.add(const SkeletonSearch());
    });
  }

  Future<void> searchfunction(
    TextEditingController controller,
    String text,
  ) async {
    if (controller.text == "") {
      setState(() {
        widgetSearch.clear();
      });
      return;
    }
    searchTimer = Timer(const Duration(milliseconds: 300), () async {
      loadSkeletonpost();
      log("$text ${controller.text}");

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
          widgetSearch.clear();
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
            widgetSearch.add(
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
                    ? const Icon(Icons.person)
                    : const Icon(Icons.groups),
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
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: widgetSearch.length,
        itemBuilder: (context, index) {
          return widgetSearch[index];
        },
      ),
    );
  }
}
