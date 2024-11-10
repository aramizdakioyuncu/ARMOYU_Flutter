import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/API_Functions/country.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/functions/API_Functions/teams.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/country.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/job.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/province.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/team.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ARMOYUFunctions {
  final UserAccounts currentUserAccounts;
  late final ApiService apiService;

  ARMOYUFunctions({required this.currentUserAccounts}) {
    apiService = ApiService(user: currentUserAccounts.user.value);
  }

  static User userfetch(response) {
    return User(
      userID: response["playerID"],
      userName: response["username"],
      firstName: response["firstName"],
      lastName: response["lastName"],
      displayName: response["displayName"],
      userMail: response["detailInfo"]["email"],
      aboutme: Rx<String>(response["detailInfo"]["about"]),
      avatar: Media(
        mediaID: response["avatar"]["media_ID"],
        ownerID: response["playerID"],
        mediaURL: MediaURL(
          bigURL: Rx<String>(response["avatar"]["media_bigURL"]),
          normalURL: Rx<String>(response["avatar"]["media_URL"]),
          minURL: Rx<String>(response["avatar"]["media_minURL"]),
        ),
      ),
      banner: Media(
        mediaID: response["banner"]["media_ID"],
        ownerID: response["playerID"],
        mediaURL: MediaURL(
          bigURL: Rx<String>(response["banner"]["media_bigURL"]),
          normalURL: Rx<String>(response["banner"]["media_URL"]),
          minURL: Rx<String>(response["banner"]["media_minURL"]),
        ),
      ),
      burc: response["burc"] == null ? null : Rx<String>(response["burc"]),
      invitecode: response["detailInfo"]["inviteCode"] == null
          ? null
          : Rx<String>(response["detailInfo"]["inviteCode"]),
      lastlogin: response["detailInfo"]["lastloginDate"] == null
          ? null
          : Rx<String>(response["detailInfo"]["lastloginDate"]),
      lastloginv2: response["detailInfo"]["lastloginDateV2"] == null
          ? null
          : Rx<String>(response["detailInfo"]["lastloginDateV2"]),
      lastfaillogin: response["detailInfo"]["lastfailedDate"] == null
          ? null
          : Rx<String>(response["detailInfo"]["lastfailedDate"]),
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

  Future<void> selectFavTeam(context, {bool? force}) async {
    if (force == null || force == false) {
      if (currentUserAccounts.user.value.favTeam != null) {
        log("Favori Takım seçilmiş");
        return;
      }
      if (currentUserAccounts.favteamRequest) {
        log("Sorulmuş ama seçmek istememiş");
        return;
      }
    }

    await favteamfetch();

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
                          currentUserAccounts.favoriteteams!.length,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(
                                    currentUserAccounts.favoriteteams![index]);
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: currentUserAccounts
                                        .favoriteteams![index].logo,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(currentUserAccounts
                                      .favoriteteams![index].name),
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
      currentUserAccounts.favteamRequest = true;
    });
  }

  Future<void> favteamselect(Team? team) async {
    FunctionsProfile f =
        FunctionsProfile(currentUser: currentUserAccounts.user.value);
    Map<String, dynamic> response = await f.selectfavteam(team?.teamID);
    log(response.toString());
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }
    if (team != null) {
      currentUserAccounts.user.value.favTeam =
          Team(teamID: team.teamID, name: team.name, logo: team.logo);
    } else {
      currentUserAccounts.user.value.favTeam = null;
    }
  }

  Future<void> favteamfetch() async {
    if (currentUserAccounts.favoriteteams == null) {
      FunctionsTeams f =
          FunctionsTeams(currentUser: currentUserAccounts.user.value);
      Map<String, dynamic> response = await f.fetch();
      if (response["durum"] == 0) {
        log(response["aciklama"].toString());
        favteamfetch();
        return;
      }

      currentUserAccounts.favoriteteams = [];

      for (int i = 0; response["icerik"].length > i; i++) {
        currentUserAccounts.favoriteteams!.add(
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

  Future<void> fetchCountry(
    setstatefunction,
  ) async {
    FunctionsCountry f =
        FunctionsCountry(currentUser: currentUserAccounts.user.value);
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

      if (currentUserAccounts.user.value.country != null) {
        if (country["country_ID"] ==
            currentUserAccounts.user.value.country!.countryID) {
          fetchProvince(
            currentUserAccounts.user.value.country!.countryID,
            ARMOYU.countryList.length - 1,
            setstatefunction,
          );
        }
      }
    }
  }

  Future<void> fetchProvince(
      int countryID, selectedIndex, setstatefunction) async {
    if (ARMOYU.countryList[selectedIndex].provinceList != null) {
      if (ARMOYU.countryList[selectedIndex].provinceList!.isNotEmpty) {
        provinceSelectStatus = true;
      } else {
        provinceSelectStatus = false;
      }
      return;
    }
    FunctionsCountry f =
        FunctionsCountry(currentUser: currentUserAccounts.user.value);
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

  void profileEdit(BuildContext context, Function setstatefunction) {
    FocusNode myFocusPassword = FocusNode();

    var firstName = TextEditingController().obs;
    firstName.value.text = currentUserAccounts.user.value.firstName.toString();

    var lastName = TextEditingController().obs;
    lastName.value.text = currentUserAccounts.user.value.lastName.toString();

    var aboutme = TextEditingController().obs;
    aboutme.value.text = currentUserAccounts.user.value.aboutme.toString();

    var email = TextEditingController().obs;
    email.value.text = currentUserAccounts.user.value.userMail.toString();

    var birthday = TextEditingController().obs;
    birthday.value.text =
        currentUserAccounts.user.value.birthdayDate.toString();

    String country = "Ülke Seçim";
    int? countryIndex = 0;
    if (currentUserAccounts.user.value.country != null) {
      country = currentUserAccounts.user.value.country!.name;
      countryIndex = currentUserAccounts.user.value.country!.countryID;
    }

    String province = "İl Seçim";
    int? provinceIndex = 0;
    if (currentUserAccounts.user.value.province != null) {
      province = currentUserAccounts.user.value.province!.name;
      provinceIndex = currentUserAccounts.user.value.province!.provinceID;
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

    var phoneNumber = TextEditingController().obs;
    phoneNumber.value.text =
        formatString(currentUserAccounts.user.value.phoneNumber.toString());

    var passwordControl = TextEditingController().obs;
    var profileeditProcess = false.obs;
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
                                child: CustomTextfields.costum3(
                                  placeholder: currentUserAccounts
                                      .user.value.displayName,
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
                                child: CustomTextfields.costum3(
                                  placeholder: currentUserAccounts
                                      .user.value.displayName,
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
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomText.costum1(
                                  "Hakkımda",
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields.costum3(
                                  placeholder: currentUserAccounts
                                      .user.value.aboutme!.value,
                                  controller: aboutme,
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
                                child: CustomTextfields.costum3(
                                  placeholder:
                                      currentUserAccounts.user.value.userMail,
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
                                            list:
                                                ARMOYU.countryList.map((item) {
                                              return {
                                                item.countryID:
                                                    item.name.toString(),
                                              };
                                            }).toList(),
                                          );
                                        },
                                        loadingStatus: false.obs,
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
                                        loadingStatus: false.obs,
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
                                  text: birthday.value.text,
                                  onPressed: () {
                                    WidgetUtility.cupertinoDatePicker(
                                      context: context,
                                      onChanged: (selectedValue) {
                                        birthday.value.text = selectedValue;
                                      },
                                      setstatefunction: setstatefunction,
                                    );
                                  },
                                  loadingStatus: false.obs,
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
                                child: CustomTextfields.number(
                                  placeholder: "(XXX) XXX XX XX",
                                  controller: phoneNumber.value,
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
                                child: CustomTextfields.costum3(
                                    controller: passwordControl,
                                    isPassword: true,
                                    focusNode: myFocusPassword),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButtons.costum1(
                            text: "Güncelle",
                            onPressed: () async {
                              String cleanedphoneNumber = phoneNumber.value.text
                                  .replaceAll(RegExp(r'[()\s]'), '');

                              List<String> words =
                                  birthday.value.text.split(".");
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

                              log(firstName.value.text);
                              log(lastName.value.text);

                              log(aboutme.value.text);

                              log(email.value.text);
                              log(countryID.toString());
                              log(provinceID.toString());
                              log(newDate);
                              log(cleanedphoneNumber);
                              log(passwordControl.value.text);

                              if (passwordControl.value.text == "") {
                                ARMOYUWidget.toastNotification(
                                    "Parola doğrulamasını yapınız!");

                                myFocusPassword.requestFocus();
                                return;
                              }

                              if (profileeditProcess.value) {
                                return;
                              }
                              profileeditProcess = true.obs;
                              setstatefunction();

                              FunctionsProfile f = FunctionsProfile(
                                currentUser: currentUserAccounts.user.value,
                              );
                              Map<String, dynamic> response =
                                  await f.saveprofiledetails(
                                firstname: firstName.value.text,
                                lastname: lastName.value.text,
                                aboutme: aboutme.value.text,
                                email: email.value.text,
                                countryID: countryID.toString(),
                                provinceID: provinceID.toString(),
                                birthday: newDate,
                                phoneNumber: cleanedphoneNumber,
                                passwordControl: passwordControl.value.text,
                              );

                              profileeditProcess.value = false;
                              setstatefunction();
                              if (response["durum"] == 0) {
                                log(response["aciklama"]);
                                ARMOYUWidget.toastNotification(
                                    response["aciklama"].toString());
                                return;
                              }
                              currentUserAccounts.user.value.firstName =
                                  firstName.value.text;
                              currentUserAccounts.user.value.lastName =
                                  lastName.value.text;
                              currentUserAccounts.user.value.displayName =
                                  "${firstName.value.text} ${lastName.value.text}";

                              currentUserAccounts.user.value.aboutme!.value =
                                  aboutme.value.text;
                              currentUserAccounts.user.value.userMail =
                                  email.value.text;
                              currentUserAccounts.user.value.country = Country(
                                countryID: int.parse(countryID),
                                name: ARMOYU.countryList[countryIndex!].name,
                                countryCode: ARMOYU
                                    .countryList[countryIndex!].countryCode,
                                phoneCode:
                                    ARMOYU.countryList[countryIndex!].phoneCode,
                              );
                              currentUserAccounts.user.value.province =
                                  Province(
                                provinceID: int.parse(provinceID),
                                name: ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].name,
                                plateCode: ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].plateCode,
                                phoneCode: ARMOYU.countryList[countryIndex!]
                                    .provinceList![provinceIndex!].phoneCode,
                              );
                              currentUserAccounts.user.value.phoneNumber =
                                  cleanedphoneNumber;
                              currentUserAccounts.user.value.birthdayDate =
                                  birthday.value.text;

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
