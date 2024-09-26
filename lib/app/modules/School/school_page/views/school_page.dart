import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/school.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SchoolPage extends StatefulWidget {
  final User currentUser;
  final School? school;
  final int schoolID;

  const SchoolPage({
    super.key,
    required this.currentUser,
    this.school,
    required this.schoolID,
  });
  @override
  State<SchoolPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SchoolPage>
    with AutomaticKeepAliveClientMixin<SchoolPage> {
  bool schoolfetchProcess = false;
  @override
  bool get wantKeepAlive => true;
  School _school = School();

  @override
  void initState() {
    super.initState();

    _school = School();
    if (widget.school == null) {
      schoolinfofetch();
    } else {
      _school = widget.school!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> schoolinfofetch() async {
    if (schoolfetchProcess) {
      return;
    }
    schoolfetchProcess = true;
    setstatefunction();
    FunctionsSchool f = FunctionsSchool(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.fetchSchool(widget.schoolID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      schoolfetchProcess = false;
      setstatefunction();
      return;
    }
    _school = School(
      schoolID: response["icerik"]["school_ID"],
      schoolName: response["icerik"]["school_name"],
      schoolshortName: response["icerik"]["school_shortname"],
      schoolURL: response["icerik"]["school_URL"],
      schoolBanner: Media(
        mediaID: response["icerik"]["school_banner"]["media_ID"],
        mediaURL: MediaURL(
          bigURL: response["icerik"]["school_banner"]["media_bigURL"],
          normalURL: response["icerik"]["school_banner"]["media_URL"],
          minURL: response["icerik"]["school_banner"]["media_minURL"],
        ),
      ),
      schoolLogo: Media(
        mediaID: response["icerik"]["school_logo"]["media_ID"],
        mediaURL: MediaURL(
          bigURL: response["icerik"]["school_logo"]["media_bigURL"],
          normalURL: response["icerik"]["school_logo"]["media_URL"],
          minURL: response["icerik"]["school_logo"]["media_minURL"],
        ),
      ),
    );

    setstatefunction();
  }

  Future<void> _handleRefresh() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              floating: false,
              backgroundColor: Colors.black,
              expandedHeight: ARMOYU.screenHeight * 0.25,
              actions: const <Widget>[],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 00.0),
                centerTitle: false,
                // expandedTitleScale: 1,
                title: Stack(
                  children: [
                    Wrap(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _school.schoolLogo == null
                                      ? Container()
                                      : CachedNetworkImage(
                                          imageUrl: _school
                                              .schoolLogo!.mediaURL.minURL,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: _school.schoolName == null
                                        ? Shimmer.fromColors(
                                            baseColor: ARMOYU.baseColor,
                                            highlightColor:
                                                ARMOYU.highlightColor,
                                            child: const SizedBox(width: 30),
                                          )
                                        //  const SkeletonLine(
                                        //     style: SkeletonLineStyle(
                                        //       width: 30,
                                        //     ),
                                        //   )
                                        : Text(
                                            _school.schoolName.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                background: GestureDetector(
                  child: _school.schoolBanner == null
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl: _school.schoolBanner!.mediaURL.minURL,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
