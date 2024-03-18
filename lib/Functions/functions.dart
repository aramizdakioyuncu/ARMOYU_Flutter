import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/teams.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ARMOYUFunctions {
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
