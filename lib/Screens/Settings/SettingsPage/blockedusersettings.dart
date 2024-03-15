import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/blocking.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsBlockeduserPage extends StatefulWidget {
  const SettingsBlockeduserPage({super.key});

  @override
  State<SettingsBlockeduserPage> createState() =>
      _SettingsBlockeduserStatePage();
}

class _SettingsBlockeduserStatePage extends State<SettingsBlockeduserPage> {
  List<Map<int, Widget>> blockedList = [];

  @override
  void initState() {
    super.initState();

    getblockedlist();
  }

  Future<void> removeblock(int userID, int index) async {
    FunctionsBlocking f = FunctionsBlocking();
    Map<String, dynamic> response = await f.remove(userID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    setState(() {
      // blockedList.removeAt(index);
      blockedList.removeWhere((element) => element.keys.first == userID);
    });
  }

  Future<void> getblockedlist() async {
    FunctionsBlocking f = FunctionsBlocking();
    Map<String, dynamic> response = await f.list();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    blockedList.clear();

    for (int i = 0; i < response['icerik'].length; i++) {
      int blockeduserID =
          int.parse(response['icerik'][i]["engel_kimeID"].toString());

      setState(() {
        blockedList.add({
          blockeduserID: ListTile(
            leading: CircleAvatar(
              radius: 20,
              foregroundImage: CachedNetworkImageProvider(
                  response['icerik'][i]["engel_avatar"].toString()),
            ),
            title: CustomText.costum1(
                response['icerik'][i]["engel_kime"].toString()),
            subtitle: Text(response['icerik'][i]["engel_kadi"].toString()),
            onTap: () {},
            trailing: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                removeblock(blockeduserID, i);
              },
              child: const Text(
                "Engellemeyi Kaldır",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        title: const Text('Engellenen Hesaplar'),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: Column(
        children: [
          Container(color: ARMOYU.bodyColor, height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: blockedList.length,
              itemBuilder: (context, index) {
                final Map<int, Widget> blockedUserMap = blockedList[index];
                final Widget userWidget = blockedUserMap.values.first;

                return userWidget;
              },
            ),
          ),
        ],
      ),
    );
  }
}
