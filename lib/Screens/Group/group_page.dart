import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/group.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class GroupPage extends StatefulWidget {
  final int groupID;
  const GroupPage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupPage> createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
  bool _groupProcces = false;
  Group _group = Group();
  @override
  void initState() {
    super.initState();

    _group.groupID = widget.groupID;
    fetchGroupInfo();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchGroupInfo() async {
    if (_groupProcces) {
      return;
    }
    _groupProcces = true;
    FunctionsGroup f = FunctionsGroup();
    Map<String, dynamic> response = await f.groupFetch(widget.groupID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      _groupProcces = false;
      return;
    }
    _group = Group(
      groupID: response["icerik"]["group_ID"],
      groupName: response["icerik"]["group_name"],
      groupshortName: response["icerik"]["group_shortname"],
      groupURL: response["icerik"]["group_URL"],
      groupType: "",
      groupBanner: Media(
        mediaID: response["icerik"]["group_banner"]["media_ID"],
        mediaURL: MediaURL(
          bigURL: response["icerik"]["group_banner"]["media_bigURL"],
          normalURL: response["icerik"]["group_banner"]["media_URL"],
          minURL: response["icerik"]["group_banner"]["media_minURL"],
        ),
      ),
      groupLogo: Media(
        mediaID: response["icerik"]["group_logo"]["media_ID"],
        mediaURL: MediaURL(
          bigURL: response["icerik"]["group_logo"]["media_bigURL"],
          normalURL: response["icerik"]["group_logo"]["media_URL"],
          minURL: response["icerik"]["group_logo"]["media_minURL"],
        ),
      ),
    );
    setstatefunction();
  }

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
            actions: const <Widget>[],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 30.0),
              centerTitle: false,
              title: Stack(
                children: [
                  Wrap(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            _group.groupLogo == null
                                ? const SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: CachedNetworkImageProvider(
                                      _group.groupLogo!.mediaURL.minURL,
                                    ),
                                    radius: 24,
                                  ),
                            const SizedBox(height: 2),
                            Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: _group.groupName == null
                                  ? const SkeletonLine(
                                      style: SkeletonLineStyle(width: 100),
                                    )
                                  : Text(
                                      _group.groupName.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              background: _group.groupBanner == null
                  ? null
                  : CachedNetworkImage(
                      imageUrl: _group.groupBanner!.mediaURL.minURL,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const CupertinoActivityIndicator(),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16.0),
            ]),
          )
        ],
      ),
    );
  }
}
