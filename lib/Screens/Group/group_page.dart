import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/group.dart';
import 'package:ARMOYU/Functions/page_functions.dart';
import 'package:ARMOYU/Models/ARMOYU/role.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletons/skeletons.dart';

class GroupPage extends StatefulWidget {
  final User? currentUser;

  final int groupID;
  final Group? group;
  const GroupPage({
    super.key,
    required this.currentUser,
    required this.groupID,
    this.group,
  });

  @override
  State<GroupPage> createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
  final PageController _pageviewController = PageController(initialPage: 0);
  bool _groupProcces = false;
  bool _groupusersfetchProcces = false;
  Group _group = Group(groupUsers: []);

  final TextEditingController _groupname = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.group == null) {
      _group.groupUsers = [];
      fetchGroupInfo();
    } else {
      _group = widget.group!;
      _groupname.text = _group.groupName!;
      if (widget.group!.groupUsers == null) {
        fetchusersfunction();
      }
    }
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

    _groupname.text = _group.groupName!;
    setstatefunction();
    fetchusersfunction();
    setstatefunction();
  }

  Future<void> fetchusersfunction() async {
    if (_groupusersfetchProcces) {
      return;
    }
    _groupusersfetchProcces = true;
    setstatefunction();
    FunctionsGroup f = FunctionsGroup();
    Map<String, dynamic> response = await f.groupusersFetch(widget.groupID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      _groupProcces = false;
      return;
    }

    _group.groupUsers = [];
    for (var users in response["icerik"]) {
      _group.groupUsers!.add(
        User(
          userID: users["player_ID"],
          displayName: users["player_displayname"],
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: users["player_avatar"]["media_bigURL"],
              normalURL: users["player_avatar"]["media_URL"],
              minURL: users["player_avatar"]["media_minURL"],
            ),
          ),
          role: Role(
            roleID: 0,
            name: users["player_role"],
            color: "",
          ),
        ),
      );
    }
    _groupusersfetchProcces = false;

    setstatefunction();
  }

  void groupdetailSave() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchusersfunction();
          setstatefunction();
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: false,
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                          _group.groupLogo!.mediaURL.minURL,
                                        ),
                                        radius: 24,
                                      ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: _group.groupName == null
                                        ? const SkeletonLine(
                                            style:
                                                SkeletonLineStyle(width: 100),
                                          )
                                        : Text(
                                            _group.groupName.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
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
              )
            ];
          },
          body: Column(
            children: [
              const SizedBox(height: 16.0),
              Visibility(
                visible: widget.currentUser!.myGroups != null
                    ? widget.currentUser!.myGroups!
                        .any((mygroup) => mygroup.groupID == _group.groupID)
                    : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(0);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.house),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.userPlus),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(0);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.chartBar,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(0);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.upload),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(0);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.plug),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(0);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.gear),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageviewController.jumpToPage(0);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: PageView(
                  controller: _pageviewController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //Üye Listesi
                    Column(
                      children: [
                        _group.groupUsers == null
                            ? Column(
                                children: [
                                  SkeletonListTile(),
                                  SkeletonListTile(),
                                  SkeletonListTile(),
                                ],
                              )
                            : Column(
                                children: List.generate(
                                  _group.groupUsers!.length,
                                  (index) {
                                    return ListTile(
                                      onTap: () {
                                        PageFunctions.pushProfilePage(
                                          context,
                                          User(
                                            userID: _group
                                                .groupUsers![index].userID,
                                          ),
                                          ScrollController(),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        foregroundImage:
                                            CachedNetworkImageProvider(_group
                                                .groupUsers![index]
                                                .avatar!
                                                .mediaURL
                                                .normalURL),
                                      ),
                                      title: CustomText.costum1(
                                        _group.groupUsers![index].displayName
                                            .toString(),
                                      ),
                                      subtitle: CustomText.costum1(
                                        _group.groupUsers![index].role!.name
                                            .toString(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomText.costum1(
                              "Grup Logosu",
                            )
                          ],
                        ),
                        _group.groupLogo == null
                            ? const SkeletonItem(
                                child: SizedBox(
                                  height: 100,
                                ),
                              )
                            : Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                    _group.groupLogo!.mediaURL.minURL,
                                  )),
                                ),
                              ),
                        const SizedBox(height: 10),
                        CustomText.costum1("Değiştir"),
                        Row(
                          children: [
                            CustomText.costum1(
                              "Arkaplan Görseli",
                            ),
                          ],
                        ),
                        _group.groupBanner == null
                            ? const SkeletonItem(
                                child: SizedBox(
                                  height: 100,
                                ),
                              )
                            : Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                    _group.groupBanner!.mediaURL.minURL,
                                  )),
                                ),
                              ),
                        CustomText.costum1("Değiştir"),
                        CustomTextfields(setstate: setstatefunction).costum3(
                          controller: _groupname,
                          title: "Grup Adı",
                        ),
                        const SizedBox(height: 20),
                        CustomButtons.costum1(
                          text: "Kaydet",
                          onPressed: groupdetailSave,
                          loadingStatus: false,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
