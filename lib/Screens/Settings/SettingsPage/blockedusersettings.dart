import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/blocking.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsBlockeduserPage extends StatefulWidget {
  const SettingsBlockeduserPage({super.key});

  @override
  State<SettingsBlockeduserPage> createState() =>
      _SettingsBlockeduserStatePage();
}

List<Map<int, Widget>> _blockedList = [];
bool _blockedProcces = false;
bool _isFirstProcces = true;

class _SettingsBlockeduserStatePage extends State<SettingsBlockeduserPage> {
  @override
  void initState() {
    super.initState();
    if (_isFirstProcces) {
      getblockedlist();
    }
  }

  Future<void> removeblock(int userID, int index) async {
    FunctionsBlocking f = FunctionsBlocking();
    Map<String, dynamic> response = await f.remove(userID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    setState(() {
      _blockedList.removeWhere((element) => element.keys.first == userID);
    });
  }

  Future<void> getblockedlist() async {
    if (_blockedProcces) {
      return;
    }
    _blockedProcces = true;
    FunctionsBlocking f = FunctionsBlocking();
    Map<String, dynamic> response = await f.list();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _blockedProcces = false;
      _isFirstProcces = false;
      return;
    }

    _blockedList.clear();

    for (int i = 0; i < response['icerik'].length; i++) {
      int blockeduserID =
          int.parse(response['icerik'][i]["engel_kimeID"].toString());

      setState(() {
        _blockedList.add({
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
    _blockedProcces = false;
    _isFirstProcces = false;
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
            child: _blockedList.isEmpty
                ? Center(
                    child: _blockedProcces && _isFirstProcces
                        ? const Text("Engellenen hesap yok")
                        : const CupertinoActivityIndicator())
                : ListView.builder(
                    itemCount: _blockedList.length,
                    itemBuilder: (context, index) {
                      final Map<int, Widget> blockedUserMap =
                          _blockedList[index];
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
