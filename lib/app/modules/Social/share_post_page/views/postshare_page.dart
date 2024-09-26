import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/Utility/camera_screen_page.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/functions/API_Functions/posts.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PostSharePage extends StatefulWidget {
  final User currentUser;
  const PostSharePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<PostSharePage> createState() => _PostSharePageState();
}

class _PostSharePageState extends State<PostSharePage>
    with AutomaticKeepAliveClientMixin<PostSharePage> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  @override
  bool get wantKeepAlive => true;

  TextEditingController postsharetext = TextEditingController();
  List<Media> media = [];
  bool postshareProccess = false;

  Future<void> sharePost() async {
    if (postshareProccess) {
      return;
    }

    postshareProccess = true;
    setstatefunction();
    FunctionsPosts funct = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.share(
      key.currentState!.controller!.text,
      media,
      location: userLocation,
    );
    if (response["durum"] == 0) {
      postsharetext.text = response["aciklama"].toString();
      postshareProccess = false;
      setstatefunction();

      return;
    }

    if (response["durum"] == 1) {
      postsharetext.text = response["aciklama"].toString();
      postshareProccess = false;
      setstatefunction();

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
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text("Paylaşım Yap"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Media.mediaList(
                media,
                setstatefunction,
                big: true,
                currentUser: widget.currentUser,
              ),
              SizedBox(
                width: ARMOYU.screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userLocation == null
                          ? Container()
                          : Stack(
                              children: [
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
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              CustomTextfields(setstate: setstatefunction).mentionTextFiled(
                key: key,
                minLines: 3,
                currentUser: widget.currentUser,
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
                          ARMOYUWidget.toastNotification(
                              "${place.street}, ${place.subLocality} ,${place.subAdministrativeArea}, ${place.postalCode}");
                          setstatefunction();
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
                      onPressed: () {
                        key.currentState!.controller!.text += "@";
                      },
                      icon: const Icon(
                        Icons.person_2,
                        color: Colors.amber,
                      ),
                    ),
                    const Spacer(),
                    if (ARMOYU.cameras!.isNotEmpty)
                      IconButton(
                        onPressed: () async {
                          final List<Media> photo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                currentUser: widget.currentUser,
                                canPop: true,
                              ),
                            ),
                          );
                          for (var element in photo) {
                            log(element.mediaURL.minURL);
                          }
                          media += photo;
                          setstatefunction();
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.deepPurple,
                        ),
                      ),
                    if (ARMOYU.cameras!.isNotEmpty) const Spacer(),
                    IconButton(
                      onPressed: () {
                        key.currentState!.controller!.text += "#";
                      },
                      icon: const Icon(
                        Icons.numbers_rounded,
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
