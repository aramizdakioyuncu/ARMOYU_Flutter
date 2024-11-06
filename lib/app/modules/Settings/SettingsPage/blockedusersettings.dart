import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/blocking.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsBlockeduserPage extends StatefulWidget {
  final User currentUser;
  const SettingsBlockeduserPage({
    super.key,
    required this.currentUser,
  });

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

    log(_blockedList.length.toString());
  }

  Future<void> removeblock(int userID, int index) async {
    FunctionsBlocking f = FunctionsBlocking(currentUser: widget.currentUser);
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
    FunctionsBlocking f = FunctionsBlocking(currentUser: widget.currentUser);
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
                backgroundColor: WidgetStatePropertyAll(Colors.blue),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                ),
                shape: WidgetStatePropertyAll(
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
              child: Text(
                BlockedListKeys.unblock.tr,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        });
      });
    }
    _blockedProcces = false;
    _isFirstProcces = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        title: Text(
          SettingsKeys.blockedList.tr,
        ),
        // backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
              onPressed: () async => await getblockedlist(),
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Container(color: ARMOYU.bodyColor, height: 1),
          Expanded(
            child: _blockedList.isEmpty
                ? Center(
                    child: !_blockedProcces && !_isFirstProcces
                        ? Text(BlockedListKeys.noBlockedAccounts.tr)
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
