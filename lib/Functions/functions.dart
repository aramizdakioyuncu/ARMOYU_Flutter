import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/teams.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Widgets/text.dart';
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

                String cevap = AppCore.getDevice();

                if (cevap == "Android") {
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
      if (ARMOYU.Appuser.favTeam != null) {
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
      ARMOYU.Appuser.favTeam =
          Team(teamID: team.teamID, name: team.name, logo: team.logo);
    } else {
      ARMOYU.Appuser.favTeam = null;
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
}
