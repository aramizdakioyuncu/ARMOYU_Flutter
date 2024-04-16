import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/teams.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ARMOYUFunctions {
  // Play Store'u açan metod

  static void openPlayStore() async {
    if (await canLaunchUrl(Uri.parse(
        "https://play.google.com/store/apps/details?id=com.ARMOYU"))) {
      await launchUrl(Uri.parse(
          "https://play.google.com/store/apps/details?id=com.ARMOYU"));
    } else {
      throw 'App Store açılamadı!';
    }
  }

  // App Store'u açan metod
  static void openAppStore() async {
    if (await canLaunchUrl(
        Uri.parse("https://apps.apple.com/tr/app/armoyu/id6448871009?l=tr"))) {
      await launchUrl(
          Uri.parse("https://apps.apple.com/tr/app/armoyu/id6448871009?l=tr"));
    } else {
      throw 'App Store açılamadı!';
    }
  }

  static void updateForce(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uygulama Güncelleme'),
          content: const Text(
              'Uygulama desteği kesildi. Lütfen güncelleme yapınız.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                if (ARMOYU.devicePlatform == "Android") {
                  ARMOYUFunctions.openPlayStore();
                } else {
                  ARMOYUFunctions.openAppStore();
                }
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  static void selectFavTeam(context, {bool? force}) {
    if (force == null || force == false) {
      if (ARMOYU.appUser.favTeam != null) {
        log("Favori Takım seçilmiş");
        return;
      }
      if (ARMOYU.favteamRequest) {
        log("Sorulmuş ama seçmek istememiş");
        return;
      }
    }

    favteamfetch();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: ARMOYU.screenWidth * 0.95,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Favori Takımını Seç',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          ARMOYU.favoriteteams.length,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pop(ARMOYU.favoriteteams[index]);
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: ARMOYU.favoriteteams[index].logo,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(ARMOYU.favoriteteams[index].name),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.center,
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(null);
                            },
                            child: CustomText.costum1("Bunlardan Hiçbiri")))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((selectedTeam) {
      // Kullanıcının seçtiği takımı işle
      if (selectedTeam != null) {
        log('Seçilen Takım: ${selectedTeam.name}');
        favteamselect(selectedTeam);
      } else {
        favteamselect(null);
      }
      ARMOYU.favteamRequest = true;
    });
  }

  static Future<void> favteamselect(Team? team) async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.selectfavteam(team?.teamID);
    log(response.toString());
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }
    if (team != null) {
      ARMOYU.appUser.favTeam =
          Team(teamID: team.teamID, name: team.name, logo: team.logo);
    } else {
      ARMOYU.appUser.favTeam = null;
    }
  }

  static Future<void> favteamfetch() async {
    if (ARMOYU.favoriteteams.isEmpty) {
      FunctionsTeams f = FunctionsTeams();
      Map<String, dynamic> response = await f.fetch();
      if (response["durum"] == 0) {
        log(response["aciklama"].toString());
        return;
      }

      for (int i = 0; response["icerik"].length > i; i++) {
        ARMOYU.favoriteteams.add(
          Team(
            teamID: response["icerik"][i]["takim_ID"],
            name: response["icerik"][i]["takim_adi"],
            logo: response["icerik"][i]["takim_logo"],
          ),
        );
      }
    }
  }

  static void profileEdit(BuildContext context, Function setstatefunction) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 45.0),
                    child: CachedNetworkImage(
                      imageUrl: ARMOYU.appUser.banner!.mediaURL.normalURL,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 0,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                            ARMOYU.appUser.avatar!.mediaURL.normalURL,
                          ),
                          radius: 40,
                        ),
                        Positioned(
                          left: 25,
                          top: 25,
                          child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: CustomText.costum1(
                            "Ad Soyad",
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: CustomTextfields(setstate: setstatefunction)
                              .costum3(
                            placeholder: ARMOYU.appUser.displayName,
                            controller: TextEditingController(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: CustomText.costum1(
                            "Hakkımda",
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: CustomTextfields(setstate: setstatefunction)
                              .costum3(
                            placeholder: ARMOYU.appUser.aboutme,
                            controller: TextEditingController(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: CustomText.costum1(
                            "Konum",
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: CustomTextfields(setstate: setstatefunction)
                              .costum3(
                            placeholder: ARMOYU.appUser.country,
                            controller: TextEditingController(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: CustomText.costum1(
                            "Doğum Tarihi",
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: CustomButtons.costum1(
                              text: "text",
                              onPressed: () {
                                WidgetUtility.cupertinoDatePicker(
                                  context: context,
                                  onChanged: (p0) {},
                                  setstatefunction: setstatefunction,
                                );
                              },
                              loadingStatus: false),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: CustomText.costum1(
                            "Cep Telefon",
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: CustomTextfields(setstate: setstatefunction)
                              .costum3(
                            placeholder: ARMOYU.appUser.userID.toString(),
                            controller: TextEditingController(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButtons.costum1(
                      text: "Güncelle",
                      onPressed: () {},
                      loadingStatus: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}
