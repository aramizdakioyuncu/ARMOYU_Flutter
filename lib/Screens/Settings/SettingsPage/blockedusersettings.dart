// ignore_for_file: library_private_types_in_public_api

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsBlockeduserPage extends StatefulWidget {
  const SettingsBlockeduserPage({super.key});

  @override
  _SettingsBlockeduserStatePage createState() =>
      _SettingsBlockeduserStatePage();
}

class _SettingsBlockeduserStatePage extends State<SettingsBlockeduserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engellenen Hesaplar'),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  foregroundImage: CachedNetworkImageProvider(User.avatar),
                ),
                title: CustomText().Costum1(User.displayName),
                subtitle: Text(User.userName),
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
                  onPressed: () {},
                  child: const Text(
                    "Engellemeyi Kaldır",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
