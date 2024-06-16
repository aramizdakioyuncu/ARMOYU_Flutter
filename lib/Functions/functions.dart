import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/country.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/teams.dart';
import 'package:ARMOYU/Models/ARMOYU/country.dart';
import 'package:ARMOYU/Models/ARMOYU/job.dart';
import 'package:ARMOYU/Models/ARMOYU/province.dart';
import 'package:ARMOYU/Models/ARMOYU/role.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ARMOYUFunctions {
  static User userfetch(response) {
    return User(
      userID: response["playerID"],
      userName: response["username"],
      firstName: response["firstName"],
      lastName: response["lastName"],
      displayName: response["displayName"],
      userMail: response["detailInfo"]["email"],
      aboutme: response["detailInfo"]["about"],
      avatar: Media(
        mediaID: response["avatar"]["media_ID"],
        ownerID: response["playerID"],
        mediaURL: MediaURL(
          bigURL: response["avatar"]["media_bigURL"],
          normalURL: response["avatar"]["media_URL"],
          minURL: response["avatar"]["media_minURL"],
        ),
      ),
      banner: Media(
        mediaID: response["banner"]["media_ID"],
        ownerID: response["playerID"],
        mediaURL: MediaURL(
          bigURL: response["banner"]["media_bigURL"],
          normalURL: response["banner"]["media_URL"],
          minURL: response["banner"]["media_minURL"],
        ),
      ),
      burc: response["burc"],
      invitecode: response["detailInfo"]["inviteCode"],
      lastlogin: response["detailInfo"]["lastloginDate"],
      lastloginv2: response["detailInfo"]["lastloginDateV2"],
      lastfaillogin: response["detailInfo"]["lastfailedDate"],
      job: response["job"] == null
          ? null
          : Job(
              jobID: response["job"]["job_ID"],
              name: response["job"]["job_name"],
              shortName: response["job"]["job_shortName"],
            ),
      level: response["level"],
      levelColor: response["levelColor"],
      xp: response["levelXP"],
      awardsCount: response["detailInfo"]["awards"],
      postsCount: response["detailInfo"]["posts"],
      friendsCount: response["detailInfo"]["friends"],
      country: response["detailInfo"]["country"] == null
          ? null
          : Country(
              countryID: response["detailInfo"]["country"]["country_ID"],
              name: response["detailInfo"]["country"]["country_name"],
              countryCode: response["detailInfo"]["country"]["country_code"],
              phoneCode: response["detailInfo"]["country"]["country_phoneCode"],
            ),
      province: response["detailInfo"]["province"] == null
          ? null
          : Province(
              provinceID: response["detailInfo"]["province"]["province_ID"],
              name: response["detailInfo"]["province"]["province_name"],
              plateCode: response["detailInfo"]["province"]
                  ["province_plateCode"],
              phoneCode: response["detailInfo"]["province"]
                  ["province_phoneCode"],
            ),
      registerDate: response["registeredDateV2"],
      role: Role(
        roleID: response["roleID"],
        name: response["roleName"],
        color: response["roleColor"],
      ),
      birthdayDate: response["detailInfo"]["birthdayDate"],
      phoneNumber: response["detailInfo"]["phoneNumber"],
      favTeam: response["favTeam"] != null
          ? Team(
              teamID: response["favTeam"]["team_ID"],
              name: response["favTeam"]["team_name"],
              logo: response["favTeam"]["team_logo"],
            )
          : null,
    );
  }

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
      if (ARMOYU.appUsers[ARMOYU.selectedUser].favTeam != null) {
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
                        child: CustomText.costum1("Bunlardan Hiçbiri"),
                      ),
                    )
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
      ARMOYU.appUsers[ARMOYU.selectedUser].favTeam =
          Team(teamID: team.teamID, name: team.name, logo: team.logo);
    } else {
      ARMOYU.appUsers[ARMOYU.selectedUser].favTeam = null;
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
      ARMOYU.favoriteteams.clear();

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

  static String formatString(String str) {
    if (str == "null" || str.isEmpty || str.length < 10) {
      return str;
    }
    String formattedStr = "(";

    formattedStr += "${str.substring(0, 3)}) ";

    formattedStr += "${str.substring(3, 6)} ";

    formattedStr += "${str.substring(6, 8)} ";

    formattedStr += str.substring(8);

    return formattedStr;
  }

  static Future<void> fetchCountry(
    setstatefunction,
  ) async {
    FunctionsCountry f = FunctionsCountry();
    Map<String, dynamic> response = await f.fetch();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }
    ARMOYU.countryList.clear();

    for (var country in response["icerik"]) {
      ARMOYU.countryList.add(
        Country(
          countryID: country["country_ID"],
          name: country["country_name"],
          countryCode: country["country_code"],
          phoneCode: country["country_phoneCode"],
        ),
      );

      if (ARMOYU.appUsers[ARMOYU.selectedUser].country != null) {
        if (country["country_ID"] ==
            ARMOYU.appUsers[ARMOYU.selectedUser].country!.countryID) {
          fetchProvince(
            ARMOYU.appUsers[ARMOYU.selectedUser].country!.countryID,
            ARMOYU.countryList.length - 1,
            setstatefunction,
          );
        }
      }
    }
  }

  static Future<void> fetchProvince(
      int countryID, selectedIndex, setstatefunction) async {
    if (ARMOYU.countryList[selectedIndex].provinceList != null) {
      if (ARMOYU.countryList[selectedIndex].provinceList!.isNotEmpty) {
        provinceSelectStatus = true;
      } else {
        provinceSelectStatus = false;
      }
      return;
    }
    FunctionsCountry f = FunctionsCountry();
    Map<String, dynamic> response = await f.fetchprovince(countryID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    if (response["icerik"].length == 0) {
      provinceSelectStatus = false;
      return;
    }
    List<Province> provinceList = [];

    for (var province in response["icerik"]) {
      log(province["province_name"].toString());
      provinceList.add(
        Province(
          provinceID: province["province_ID"],
          name: province["province_name"],
          plateCode: province["province_plateCode"],
          phoneCode: province["province_phoneCode"],
        ),
      );
    }

    ARMOYU.countryList.elementAt(selectedIndex).provinceList = provinceList;

    if (provinceList.isNotEmpty) {
      provinceSelectStatus = true;
    } else {
      provinceSelectStatus = false;
    }
    setstatefunction();
  }

  static bool provinceSelectStatus = false;

  static void profileEdit(BuildContext context, Function setstatefunction) {
    final TextEditingController firstName = TextEditingController();
    firstName.text = ARMOYU.appUsers[ARMOYU.selectedUser].firstName.toString();
    final TextEditingController lastName = TextEditingController();
    lastName.text = ARMOYU.appUsers[ARMOYU.selectedUser].lastName.toString();

    final TextEditingController email = TextEditingController();
    email.text = ARMOYU.appUsers[ARMOYU.selectedUser].userMail.toString();

    final TextEditingController birthday = TextEditingController();
    birthday.text =
        ARMOYU.appUsers[ARMOYU.selectedUser].birthdayDate.toString();

    String country = "Ülke Seçim";
    int? countryIndex = 0;
    if (ARMOYU.appUsers[ARMOYU.selectedUser].country != null) {
      country = ARMOYU.appUsers[ARMOYU.selectedUser].country!.name;
      countryIndex = ARMOYU.appUsers[ARMOYU.selectedUser].country!.countryID;
    }

    String province = "İl Seçim";
    int? provinceIndex = 0;
    if (ARMOYU.appUsers[ARMOYU.selectedUser].province != null) {
      province = ARMOYU.appUsers[ARMOYU.selectedUser].province!.name;
      provinceIndex = ARMOYU.appUsers[ARMOYU.selectedUser].province!.provinceID;
    }

    if (ARMOYU.countryList.isNotEmpty) {
      if (ARMOYU.countryList[countryIndex].provinceList != null) {
        provinceSelectStatus = true;
        setstatefunction();
      }
    }
    Timer? searchTimer;

    if (ARMOYU.countryList.isEmpty) {
      fetchCountry(setstatefunction);
    }

    final TextEditingController phoneNumber = TextEditingController();
    phoneNumber.text = formatString(
        ARMOYU.appUsers[ARMOYU.selectedUser].phoneNumber.toString());

    final TextEditingController passwordControl = TextEditingController();
    bool profileeditProcess = false;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.87,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                                  "Ad",
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child:
                                    CustomTextfields(setstate: setstatefunction)
                                        .costum3(
                                  placeholder: ARMOYU
                                      .appUsers[ARMOYU.selectedUser]
                                      .displayName,
                                  controller: firstName,
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
                                  "Soyad",
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child:
                                    CustomTextfields(setstate: setstatefunction)
                                        .costum3(
                                  placeholder: ARMOYU
                                      .appUsers[ARMOYU.selectedUser]
                                      .displayName,
                                  controller: lastName,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: 100,
                                  child: CustomText.costum1(
                                    "E-posta",
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                    CustomTextfields(setstate: setstatefunction)
                                        .costum3(
                                  placeholder: ARMOYU
                                      .appUsers[ARMOYU.selectedUser].userMail,
                                  controller: email,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CustomButtons.costum1(
                                        text: country,
                                        onPressed: () {
                                          WidgetUtility.cupertinoselector(
                                            context: context,
                                            title: "Ülke Seçim",
                                            onChanged:
                                                (selectedIndex, selectedValue) {
                                              if (selectedIndex == -1) {
                                                return;
                                              }
                                              provinceSelectStatus = false;
                                              province = "İl Seçim";
                                              country = selectedValue;
                                              countryIndex = selectedIndex;

                                              int countryID = ARMOYU
                                                  .countryList[selectedIndex]
                                                  .countryID;

                                              searchTimer?.cancel();
                                              searchTimer = Timer(
                                                  const Duration(
                                                      milliseconds: 1000),
                                                  () async {
                                                await fetchProvince(
                                                  countryID,
                                                  selectedIndex,
                                                  setstatefunction,
                                                );
                                              });
                                            },
                                            setstatefunction: setstatefunction,
                                            list:
                                                ARMOYU.countryList.map((item) {
                                              return {
                                                item.countryID:
                                                    item.name.toString(),
                                              };
                                            }).toList(),
                                          );
                                        },
                                        loadingStatus: false,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomButtons.costum1(
                                        text: province,
                                        enabled: provinceSelectStatus,
                                        onPressed: () {
                                          WidgetUtility.cupertinoselector(
                                            context: context,
                                            title: "İl Seçim",
                                            onChanged:
                                                (selectedIndex, selectedValue) {
                                              provinceIndex = selectedIndex;
                                              province = selectedValue;
                                            },
                                            setstatefunction: setstatefunction,
                                            list: ARMOYU
                                                .countryList[countryIndex!]
                                                .provinceList!
                                                .map((item) {
                                              return {
                                                item.provinceID:
                                                    item.name.toString(),
                                              };
                                            }).toList(),
                                          );
                                        },
                                        loadingStatus: false,
                                      ),
                                    ),
                                  ],
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
                                  text: birthday.text,
                                  onPressed: () {
                                    WidgetUtility.cupertinoDatePicker(
                                      context: context,
                                      onChanged: (selectedValue) {
                                        birthday.text = selectedValue;
                                      },
                                      setstatefunction: setstatefunction,
                                    );
                                  },
                                  loadingStatus: false,
                                ),
                              ),
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
                                child:
                                    CustomTextfields(setstate: setstatefunction)
                                        .number(
                                  placeholder: "(XXX) XXX XX XX",
                                  controller: phoneNumber,
                                  icon: const Icon(Icons.phone),
                                  category: "phoneNumber",
                                  length: 10,
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
                                  "Parola Kontrolü",
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child:
                                    CustomTextfields(setstate: setstatefunction)
                                        .costum3(
                                  controller: passwordControl,
                                  isPassword: true,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButtons.costum1(
                            text: "Güncelle",
                            onPressed: () async {
                              String cleanedphoneNumber = phoneNumber.text
                                  .replaceAll(RegExp(r'[()\s]'), '');

                              List<String> words = birthday.text.split(".");
                              if (words.isEmpty) {
                                return;
                              }
                              String newDate =
                                  "${words[2]}-${words[1]}-${words[0]}";

                              String countryID = "";
                              countryID = ARMOYU
                                  .countryList[countryIndex!].countryID
                                  .toString();

                              String provinceID = "";
                              if (ARMOYU.countryList[countryIndex!]
                                      .provinceList !=
                                  null) {
                                provinceID = ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].provinceID
                                    .toString();
                              }

                              log(firstName.text);
                              log(lastName.text);
                              log(email.text);
                              log(countryID.toString());
                              log(provinceID.toString());
                              log(newDate);
                              log(cleanedphoneNumber);
                              log(passwordControl.text);

                              if (profileeditProcess) {
                                return;
                              }
                              profileeditProcess = true;
                              setstatefunction();

                              FunctionsProfile f = FunctionsProfile();
                              Map<String, dynamic> response =
                                  await f.saveprofiledetails(
                                firstname: firstName.text,
                                lastname: lastName.text,
                                email: email.text,
                                countryID: countryID.toString(),
                                provinceID: provinceID.toString(),
                                birthday: newDate,
                                phoneNumber: cleanedphoneNumber,
                                passwordControl: passwordControl.text,
                              );

                              profileeditProcess = false;
                              setstatefunction();
                              if (response["durum"] == 0) {
                                log(response["aciklama"]);
                                ARMOYUWidget.toastNotification(
                                    response["aciklama"].toString());
                                return;
                              }
                              ARMOYU.appUsers[ARMOYU.selectedUser].firstName =
                                  firstName.text;
                              ARMOYU.appUsers[ARMOYU.selectedUser].lastName =
                                  lastName.text;
                              ARMOYU.appUsers[ARMOYU.selectedUser].displayName =
                                  "${firstName.text} ${lastName.text}";
                              ARMOYU.appUsers[ARMOYU.selectedUser].userMail =
                                  email.text;
                              ARMOYU.appUsers[ARMOYU.selectedUser].country =
                                  Country(
                                countryID: int.parse(countryID),
                                name: ARMOYU.countryList[countryIndex!].name,
                                countryCode: ARMOYU
                                    .countryList[countryIndex!].countryCode,
                                phoneCode:
                                    ARMOYU.countryList[countryIndex!].phoneCode,
                              );
                              ARMOYU.appUsers[ARMOYU.selectedUser].province =
                                  Province(
                                provinceID: int.parse(provinceID),
                                name: ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].name,
                                plateCode: ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].plateCode,
                                phoneCode: ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].phoneCode,
                              );
                              ARMOYU.appUsers[ARMOYU.selectedUser].phoneNumber =
                                  cleanedphoneNumber;
                              ARMOYU.appUsers[ARMOYU.selectedUser]
                                  .birthdayDate = birthday.text;

                              ARMOYUWidget.toastNotification(
                                  response["aciklama"].toString());
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            loadingStatus: profileeditProcess,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
