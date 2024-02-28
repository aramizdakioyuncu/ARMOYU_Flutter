// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_call_super

import 'dart:async';
import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/search_engine.dart';
import 'package:ARMOYU/Screens/Chat/chatdetail_page.dart';

class ChatPage extends StatefulWidget {
  final bool appbar;

  ChatPage({required this.appbar});

  @override
  _ChatPageState createState() => _ChatPageState();
}

final ScrollController _scrollController = ScrollController();

List<Widget> Widget_search = [];
List<Widget> filtered_Widget_search = [];

bool chatsearchprocess = false;

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    if (!chatsearchprocess) {
      getchat();
      chatsearchprocess = true;
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      chatsearchprocess = false;
      getchat();
    });
  }

  Future<void> getchat() async {
    if (chatsearchprocess) {
      return;
    }
    Widget_search.clear();
    chatsearchprocess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getchats(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    int dynamicItemCount = response["icerik"].length;

    for (int i = 0; i < dynamicItemCount; i++) {
      void asad() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (pagecontext) => ChatDetailPage(
                userID: response["icerik"][i]["kullid"],
                appbar: true,
                useravatar: response["icerik"][i]["foto"],
                userdisplayname: response["icerik"][i]["adisoyadi"])));
      }

      setState(() {
        Widget_search.add(CustomSearchEngine().chat(
          asad,
          response["icerik"][i]["kullid"],
          response["icerik"][i]["adisoyadi"],
          response["icerik"][i]["foto"],
          response["icerik"][i]["sohbetturu"],
        ));
      });
    }

    filtered_Widget_search.addAll(Widget_search);
    // widget.searchController.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: widget.appbar
          ? AppBar(
              title: Text("Sohbetler"),
              automaticallyImplyLeading: false,
              backgroundColor: ARMOYU.appbarColor,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: Widget_search.length,
          itemBuilder: (BuildContext context, index) {
            return Widget_search[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ARMOYU.buttonColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}
