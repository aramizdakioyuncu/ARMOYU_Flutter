import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Screens/Utility/camera_screen_page.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PostSharePage extends StatefulWidget {
  const PostSharePage({super.key});

  @override
  State<PostSharePage> createState() => _PostSharePageState();
}

class _PostSharePageState extends State<PostSharePage>
    with AutomaticKeepAliveClientMixin<PostSharePage> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  @override
  bool get wantKeepAlive => true;

  // TextEditingController textController = TextEditingController();
  TextEditingController postsharetext = TextEditingController();
  List<Media> media = [];
  bool postshareProccess = false;

  Future<void> sharePost() async {
    if (postshareProccess) {
      return;
    }

    setState(() {
      postshareProccess = true;
    });
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response =
        await funct.share(key.currentState!.controller!.text, media);
    if (response["durum"] == 0) {
      postsharetext.text = response["aciklama"].toString();
      if (mounted) {
        setState(() {
          postshareProccess = false;
        });
      }
      return;
    }

    if (response["durum"] == 1) {
      postsharetext.text = response["aciklama"].toString();
      setState(() {
        postshareProccess = false;
      });
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  String? userLocation;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text("Paylaşım Yap"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Media.mediaList(media, setstatefunction, big: true),
              SizedBox(
                width: ARMOYU.screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userLocation == null
                          ? Container()
                          : Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButtons.costum2(
                                  text: userLocation,
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () {},
                                ),
                              ),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: InkWell(
                                  onTap: () {
                                    userLocation = null;
                                    setstatefunction();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ]),
                    ],
                  ),
                ),
              ),
              CustomTextfields(setstate: setstatefunction).mentionTextFiled(
                key: key,
                minLines: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        dynamic aa = await _determinePosition();
                        log(aa.toString());

                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);

                        await placemarkFromCoordinates(
                                position.latitude, position.longitude)
                            .then((List<Placemark> placemarks) {
                          Placemark place = placemarks[0];
                          userLocation = place.subAdministrativeArea.toString();
                          setState(() {
                            ARMOYUWidget.toastNotification(
                                "${place.street}, ${place.subLocality} ,${place.subAdministrativeArea}, ${place.postalCode}");
                            log("${place.street}, ${place.subLocality} ,${place.subAdministrativeArea}, ${place.postalCode}");
                          });
                        }).catchError((e) {
                          debugPrint(e);
                        });
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_2,
                        color: Colors.amber,
                      ),
                    ),
                    const Spacer(),
                    if (ARMOYU.cameras!.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.deepPurple,
                        ),
                      ),
                    if (ARMOYU.cameras!.isNotEmpty) const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    CustomButtons.costum1(
                      text: "Paylaş",
                      onPressed: sharePost,
                      loadingStatus: postshareProccess,
                    ),
                    const SizedBox(height: 10),
                    Text(postsharetext.text),
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
