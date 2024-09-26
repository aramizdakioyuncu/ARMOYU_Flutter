import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/API_Functions/group.dart';
import 'package:ARMOYU/app/functions/API_Functions/search.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/shimmer/placeholder.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class GroupPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;

  final int groupID;
  final Group? group;
  const GroupPage({
    super.key,
    required this.currentUserAccounts,
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

  bool _ismyGroup = false;

  final TextEditingController _groupname = TextEditingController();
  final TextEditingController _groupshortname = TextEditingController();
  final TextEditingController _groupdescription = TextEditingController();

  final TextEditingController _socialdiscord = TextEditingController();
  final TextEditingController _socialweb = TextEditingController();

  final TextEditingController _searchuser = TextEditingController();

  final List<User> _searchuserList = [];
  final List<User> _selectedUsers = [];

  bool _groupdetailSave = false;
  bool _changegrouplogoStatus = false;
  bool _changegroupbannerStatus = false;
  bool _inviteuserStatus = false;
  int _selectedmenuItem = 0;

  final Color _selectedColor = Colors.yellow;
  final Color _nonselectedColor = Colors.white;

  Timer? searchTimer;

  @override
  void initState() {
    super.initState();

    _searchuser.addListener(_onSearchTextChanged);

    startingfunction();
  }

  Future<void> startingfunction() async {
    if (widget.group == null) {
      _group.groupUsers = [];
      await fetchGroupInfo();
    } else {
      _group = widget.group!;
      _groupname.text = _group.groupName!;
      _groupshortname.text = _group.groupshortName!;
      _socialweb.text = _group.groupSocial!.web.toString();
      _socialdiscord.text = _group.groupSocial!.discord.toString();
      _groupdescription.text =
          _group.description == null ? "" : _group.description.toString();
      if (widget.group!.groupUsers == null) {
        fetchusersfunction();
      }
    }

    if (widget.currentUserAccounts.user.myGroups == null) {
      _ismyGroup = false;
      return;
    }

    if (widget.currentUserAccounts.user.myGroups!
        .any((mygroup) => mygroup.groupID == _group.groupID)) {
      _ismyGroup = true;
    }
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> inviteuserfunction() async {
    if (_inviteuserStatus) {
      return;
    }

    _inviteuserStatus = true;
    setstatefunction();
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response =
        await f.userInvite(groupID: widget.groupID, userList: _selectedUsers);

    ARMOYUWidget.toastNotification(response["aciklama"].toString());

    if (response["durum"] == 0) {
      _inviteuserStatus = false;
      setstatefunction();
      return;
    }

    for (var element in response["icerik"]) {
      log("${element["aciklama"]} -- ${element["aciklamadetay"]}");
    }
    _selectedUsers.clear();

    _inviteuserStatus = false;
    setstatefunction();
  }

  void _onSearchTextChanged() {
    searchfunction(_searchuser, _searchuser.text);
  }

  Future<void> fetchGroupInfo() async {
    if (_groupProcces) {
      return;
    }
    _groupProcces = true;
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
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
      joinStatus: response["icerik"]['group_joinstatus'] == 1 ? true : false,
      description: response["icerik"]["group_description"],
      groupSocial: GroupSocial(
        discord: response["icerik"]['group_social']['group_discord'].toString(),
        web: response["icerik"]['group_social']['group_website'] ?? "",
      ),
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
    _groupshortname.text = _group.groupshortName!;

    _socialweb.text = _group.groupSocial!.web.toString();
    _socialdiscord.text = _group.groupSocial!.discord.toString();
    _groupdescription.text =
        _group.description == null ? "" : _group.description.toString();
    setstatefunction();

    fetchusersfunction();
  }

  void selectmenuItem(int selectedItem) {
    _pageviewController.jumpToPage(selectedItem);
    _selectedmenuItem = selectedItem;
  }

  Future<void> fetchusersfunction() async {
    if (_groupusersfetchProcces) {
      return;
    }
    _groupusersfetchProcces = true;
    setstatefunction();
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
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
          userName: users["player_userlogin"],
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

  Future<void> removeuserfromgroup(index) async {
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.userRemove(
      groupID: widget.groupID,
      userID: _group.groupUsers![index].userID!,
    );

    ARMOYUWidget.toastNotification(response["aciklama"].toString());

    if (response["durum"] == 0) {
      return;
    }

    _group.groupUsers!.removeWhere(
        (element) => element.userID == _group.groupUsers![index].userID);

    setstatefunction();
  }

  Future<void> groupdetailSave() async {
    if (_groupdetailSave) {
      return;
    }
    _groupdetailSave = true;
    setstatefunction();
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.groupsettingsSave(
      grupID: _group.groupID!,
      groupName: _groupname.text,
      groupshortName: _groupshortname.text,
      description: _groupdescription.text,
      discordInvite: _socialdiscord.text,
      webLINK: _socialweb.text,
      joinStatus: _group.joinStatus!,
    );

    ARMOYUWidget.toastNotification(response["aciklama"].toString());
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      _groupdetailSave = false;
      setstatefunction();

      return;
    }
    _groupdetailSave = false;

    int groupIndex = widget.currentUserAccounts.user.myGroups!
        .indexWhere((element) => element.groupID == _group.groupID);

    widget.currentUserAccounts.user.myGroups![groupIndex].groupName =
        _groupname.text;
    widget.group!.groupName = _groupname.text;
    _group.groupName = _groupname.text;

    widget.currentUserAccounts.user.myGroups![groupIndex].groupshortName =
        _groupshortname.text;
    widget.group!.groupshortName = _groupshortname.text;
    _group.groupshortName = _groupshortname.text;

    widget.currentUserAccounts.user.myGroups![groupIndex].description =
        _groupdescription.text;
    widget.group!.description = _groupdescription.text;
    _group.description = _groupdescription.text;

    widget.currentUserAccounts.user.myGroups![groupIndex].groupSocial!.discord =
        _socialdiscord.text;
    widget.group!.groupSocial!.discord = _socialdiscord.text;
    _group.groupSocial!.discord = _socialdiscord.text;

    widget.currentUserAccounts.user.myGroups![groupIndex].groupSocial!.web =
        _socialweb.text;
    widget.group!.groupSocial!.web = _socialweb.text;
    _group.groupSocial!.web = _socialweb.text;

    widget.currentUserAccounts.user.myGroups![groupIndex].joinStatus =
        _group.joinStatus;
    widget.group!.joinStatus = _group.joinStatus;
    _group.joinStatus = _group.joinStatus;

    setstatefunction();
  }

  Future<void> changegrouplogo() async {
    if (_changegrouplogoStatus) {
      return;
    }

    _changegrouplogoStatus = true;
    setstatefunction();

    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.square,
    );
    if (selectedImage == null) {
      _changegrouplogoStatus = false;
      setstatefunction();
      return;
    }
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);

    log(_group.groupID.toString());
    Map<String, dynamic> response = await f.changegroupmedia(imagePath,
        groupID: _group.groupID!, category: "logo");

    ARMOYUWidget.toastNotification(response["aciklama"]);

    if (response["durum"] == 0) {
      _changegrouplogoStatus = false;
      setstatefunction();
      return;
    }

    int groupIndex = widget.currentUserAccounts.user.myGroups!
        .indexWhere((element) => element.groupID == _group.groupID);

    widget.currentUserAccounts.user.myGroups![groupIndex].groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    widget.group!.groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _group.groupLogo = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _changegrouplogoStatus = false;
    setstatefunction();
  }

  Future<void> changegroupbanner() async {
    if (_changegroupbannerStatus) {
      return;
    }

    _changegroupbannerStatus = true;
    setstatefunction();

    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.ratio16x9,
    );
    if (selectedImage == null) {
      _changegroupbannerStatus = false;
      setstatefunction();
      return;
    }
    FunctionsGroup f =
        FunctionsGroup(currentUser: widget.currentUserAccounts.user);
    List<XFile> imagePath = [];
    imagePath.add(selectedImage);

    Map<String, dynamic> response = await f.changegroupmedia(imagePath,
        groupID: _group.groupID!, category: "banner");

    ARMOYUWidget.toastNotification(response["aciklama"]);

    if (response["durum"] == 0) {
      _changegroupbannerStatus = false;
      setstatefunction();
      return;
    }

    int groupIndex = widget.currentUserAccounts.user.myGroups!
        .indexWhere((element) => element.groupID == _group.groupID);

    widget.currentUserAccounts.user.myGroups![groupIndex].groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    widget.group!.groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _group.groupBanner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: response["aciklamadetay"].toString(),
        normalURL: response["aciklamadetay"].toString(),
        minURL: response["aciklamadetay"].toString(),
      ),
    );

    _changegroupbannerStatus = false;
    setstatefunction();
  }

  Future<void> loadSkeletonpost() async {
    setState(() {
      _searchuserList.clear();
      // _searchuserList.add(const SkeletonSearch());
    });
  }

  Future<void> searchfunction(
    TextEditingController controller,
    String text,
  ) async {
    if (controller.text == "" || controller.text.isEmpty) {
      searchTimer?.cancel();

      setState(() {
        _searchuserList.clear();
      });
      return;
    }

    searchTimer = Timer(const Duration(milliseconds: 500), () async {
      loadSkeletonpost();

      log("$text ${controller.text}");

      if (text != controller.text) {
        return;
      }
      FunctionsSearchEngine f = FunctionsSearchEngine(
        currentUser: widget.currentUserAccounts.user,
      );
      Map<String, dynamic> response = await f.onlyusers(text, 1);
      if (response["durum"] == 0) {
        log(response["aciklama"]);
        return;
      }

      try {
        setState(() {
          _searchuserList.clear();
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
        _searchuserList.add(
          User(
            userID: response["icerik"][i]["ID"],
            displayName: response["icerik"][i]["Value"],
            userName: response["icerik"][i]["username"],
            avatar: Media(
              mediaID: 11,
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["avatar"],
                normalURL: response["icerik"][i]["avatar"],
                minURL: response["icerik"][i]["avatar"],
              ),
            ),
          ),
        );
      }
      setstatefunction();
    });
  }

  Future<void> leavegroup() async {
    FunctionsGroup f = FunctionsGroup(
      currentUser: widget.currentUserAccounts.user,
    );
    Map<String, dynamic> response = await f.groupleave(_group.groupID!);
    if (response["durum"] == 0) {
      ARMOYUWidget.toastNotification(response["aciklama"].toString());
      return;
    }

    widget.currentUserAccounts.user.myGroups!
        .removeWhere((element) => element.groupID == _group.groupID);

    setstatefunction();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await fetchusersfunction(),
            ),
            SliverAppBar(
              pinned: true,
              floating: false,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.black,
              expandedHeight: ARMOYU.screenHeight * 0.25,
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
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: const CircleAvatar(
                                        radius:
                                            30.0, // Adjust the radius as needed
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  // const SkeletonAvatar(
                                  //     style: SkeletonAvatarStyle(
                                  //       borderRadius: BorderRadius.all(
                                  //         Radius.circular(30),
                                  //       ),
                                  //     ),
                                  //   )
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
                                      ? Shimmer.fromColors(
                                          baseColor: ARMOYU.baseColor,
                                          highlightColor: ARMOYU.highlightColor,
                                          child: Container(width: 100),
                                        )
                                      // const SkeletonLine(
                                      //     style: SkeletonLineStyle(width: 100),
                                      //   )
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
            ),
            const SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: _ismyGroup,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: true,
                      child: GestureDetector(
                        onTap: () {
                          selectmenuItem(0);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.house,
                                color: _selectedmenuItem == 0
                                    ? _selectedColor
                                    : _nonselectedColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.currentUserAccounts.user.myGroups == null
                          ? false
                          : widget.currentUserAccounts.user.myGroups!.any(
                                  (mygroup) =>
                                      mygroup.groupID == _group.groupID)
                              ? widget.currentUserAccounts.user.myGroups!
                                  .firstWhere((mygroup) =>
                                      mygroup.groupID == _group.groupID)
                                  .myRole!
                                  .userInvite
                              : false,
                      child: GestureDetector(
                        onTap: () {
                          selectmenuItem(1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userPlus,
                                color: _selectedmenuItem == 1
                                    ? _selectedColor
                                    : _nonselectedColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.currentUserAccounts.user.myGroups == null
                          ? false
                          : widget.currentUserAccounts.user.myGroups!.any(
                                  (mygroup) =>
                                      mygroup.groupID == _group.groupID)
                              ? widget.currentUserAccounts.user.myGroups!
                                  .firstWhere((mygroup) =>
                                      mygroup.groupID == _group.groupID)
                                  .myRole!
                                  .groupSettings
                              : false,
                      child: GestureDetector(
                        onTap: () {
                          selectmenuItem(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.gear,
                                color: _selectedmenuItem == 2
                                    ? _selectedColor
                                    : _nonselectedColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.currentUserAccounts.user.myGroups == null
                          ? false
                          : widget.currentUserAccounts.user.myGroups!.any(
                                  (mygroup) =>
                                      mygroup.groupID == _group.groupID)
                              ? widget.currentUserAccounts.user.myGroups!
                                  .firstWhere((mygroup) =>
                                      mygroup.groupID == _group.groupID)
                                  .myRole!
                                  .groupSurvey
                              : false,
                      child: GestureDetector(
                        onTap: () {
                          selectmenuItem(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.chartBar,
                                color: _selectedmenuItem == 3
                                    ? _selectedColor
                                    : _nonselectedColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.currentUserAccounts.user.myGroups == null
                          ? false
                          : widget.currentUserAccounts.user.myGroups!.any(
                                  (mygroup) =>
                                      mygroup.groupID == _group.groupID)
                              ? widget.currentUserAccounts.user.myGroups!
                                  .firstWhere((mygroup) =>
                                      mygroup.groupID == _group.groupID)
                                  .myRole!
                                  .groupFiles
                              : false,
                      child: GestureDetector(
                        onTap: () {
                          selectmenuItem(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.upload,
                                color: _selectedmenuItem == 4
                                    ? _selectedColor
                                    : _nonselectedColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: GestureDetector(
                        onTap: () {
                          selectmenuItem(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.plug,
                                color: _selectedmenuItem == 5
                                    ? _selectedColor
                                    : _nonselectedColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: GestureDetector(
                        onTap: () async {
                          ARMOYUWidget.showConfirmationDialog(
                            context,
                            accept: leavegroup,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.arrowRightFromBracket,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            )
          ];
        },
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: _pageviewController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            //Üye Listesi
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async => await fetchusersfunction(),
                ),
                _group.groupUsers == null
                    ? SliverToBoxAdapter(
                        child: Column(
                          children: [
                            ShimmerPlaceholder.listTilePlaceholder(),
                            ShimmerPlaceholder.listTilePlaceholder(),
                            ShimmerPlaceholder.listTilePlaceholder(),
                            ShimmerPlaceholder.listTilePlaceholder(),
                            ShimmerPlaceholder.listTilePlaceholder(),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                        childCount: _group.groupUsers!.length,
                        (context, index) {
                          return ListTile(
                            onTap: () {
                              PageFunctions functions = PageFunctions(
                                currentUserAccounts: widget.currentUserAccounts,
                              );

                              functions.pushProfilePage(
                                context,
                                User(
                                  userID: _group.groupUsers![index].userID,
                                ),
                                ScrollController(),
                              );
                            },
                            onLongPress: () {
                              if (widget.currentUserAccounts.user.myGroups ==
                                  null) {
                                return;
                              }

                              if (!widget.currentUserAccounts.user.myGroups!
                                  .any((mygroup) =>
                                      mygroup.groupID == _group.groupID)) {
                                return;
                              }

                              if ((widget.currentUserAccounts.user.myGroups ==
                                              null
                                          ? false
                                          : widget.currentUserAccounts.user
                                                  .myGroups!
                                                  .any((mygroup) =>
                                                      mygroup.groupID ==
                                                      _group.groupID)
                                              ? widget.currentUserAccounts.user
                                                  .myGroups!
                                                  .firstWhere((mygroup) =>
                                                      mygroup.groupID ==
                                                      _group.groupID)
                                                  .myRole!
                                                  .userKick
                                              : false)
                                      .toString() ==
                                  "false") {
                                return;
                              }
                              //
                              showModalBottomSheet<void>(
                                backgroundColor: ARMOYU.backgroundcolor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[900],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                                width: ARMOYU.screenWidth / 4,
                                                height: 5,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async =>
                                                  await removeuserfromgroup(
                                                      index),
                                              child: const ListTile(
                                                textColor: Colors.red,
                                                leading: Icon(
                                                  Icons.person_off_outlined,
                                                  color: Colors.red,
                                                ),
                                                title: Text(
                                                  "Kullanıcıyı At.",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: CachedNetworkImageProvider(
                                _group.groupUsers![index].avatar!.mediaURL
                                    .normalURL,
                              ),
                            ),
                            title: CustomText.costum1(
                              _group.groupUsers![index].displayName.toString(),
                            ),
                            subtitle: CustomText.costum1(
                              _group.groupUsers![index].role!.name.toString(),
                            ),
                          );
                        },
                      ))
              ],
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CustomText.costum1("Oyuncu davet Et"),
                            const SizedBox(
                              width: 2,
                            ),
                            CustomText.costum1(
                                "(${_selectedUsers.length} Oyuncu Seçildi)"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomTextfields(setstate: setstatefunction)
                            .costum3(
                          controller: _searchuser,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtons.costum1(
                          text: "Davet Et",
                          onPressed: inviteuserfunction,
                          enabled: _selectedUsers.isNotEmpty ? true : false,
                          loadingStatus: _inviteuserStatus,
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(_searchuserList.length, (index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundImage: CachedNetworkImageProvider(
                          _searchuserList[index].avatar!.mediaURL.minURL,
                        ),
                      ),
                      title: CustomText.costum1(
                        _searchuserList[index].displayName!,
                      ),
                      trailing: _group.groupUsers!.any((element) =>
                              element.userID == _searchuserList[index].userID)
                          ? CustomText.costum1("Grup Üyesi")
                          : Checkbox(
                              value: _selectedUsers.any((element) =>
                                  element.userID ==
                                  _searchuserList[index].userID),
                              onChanged: (value) {
                                if (value == true) {
                                  _selectedUsers.add(_searchuserList[index]);
                                } else {
                                  _selectedUsers.removeWhere((element) =>
                                      element.userID ==
                                      _searchuserList[index].userID);
                                }
                                log(_selectedUsers.length.toString());

                                setstatefunction();
                              },
                            ),
                    );
                  }),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomText.costum1(
                        "Grup Logosu",
                      )
                    ],
                  ),
                  _group.groupLogo == null
                      ? Shimmer.fromColors(
                          baseColor: ARMOYU.baseColor,
                          highlightColor: ARMOYU.highlightColor,
                          child: const SizedBox(
                            height: 100,
                          ),
                        )
                      // const SkeletonItem(
                      //     child: SizedBox(
                      //       height: 100,
                      //     ),
                      //   )
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                _group.groupLogo!.mediaURL.minURL,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  CustomButtons.costum1(
                    text: "Değiştir",
                    onPressed: changegrouplogo,
                    loadingStatus: _changegrouplogoStatus,
                  ),
                  Row(
                    children: [
                      CustomText.costum1(
                        "Arkaplan Görseli",
                      ),
                    ],
                  ),
                  _group.groupBanner == null
                      ? Shimmer.fromColors(
                          baseColor: ARMOYU.baseColor,
                          highlightColor: ARMOYU.highlightColor,
                          child: const SizedBox(
                            height: 100,
                          ),
                        )
                      // const SkeletonItem(
                      //     child: SizedBox(
                      //       height: 100,
                      //     ),
                      //   )
                      : Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                              _group.groupBanner!.mediaURL.minURL,
                            )),
                          ),
                        ),
                  CustomButtons.costum1(
                    text: "Değiştir",
                    onPressed: changegroupbanner,
                    loadingStatus: _changegroupbannerStatus,
                  ),
                  CustomTextfields(setstate: setstatefunction).costum3(
                    controller: _groupname,
                    title: "Grup Adı",
                  ),
                  const SizedBox(height: 20),
                  CustomTextfields(setstate: setstatefunction).costum3(
                    controller: _groupshortname,
                    title: "Grup Etiketi",
                  ),
                  const SizedBox(height: 20),
                  CustomTextfields(setstate: setstatefunction).costum3(
                    controller: _groupdescription,
                    title: "Grup Açıklaması",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText.costum1("Alım Durumu"),
                      const Spacer(),
                      _group.joinStatus == null
                          ? Container()
                          : Switch(
                              value: _group.joinStatus!,
                              onChanged: (value) {
                                _group.joinStatus = value;
                              },
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextfields(setstate: setstatefunction).costum3(
                    controller: _socialdiscord,
                    title: "Discord Davet Linki",
                  ),
                  const SizedBox(height: 20),
                  CustomTextfields(setstate: setstatefunction).costum3(
                    controller: _socialweb,
                    title: "Web sitesi",
                  ),
                  const SizedBox(height: 20),
                  CustomButtons.costum1(
                    text: "Kaydet",
                    onPressed: groupdetailSave,
                    loadingStatus: _groupdetailSave,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
