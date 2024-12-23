import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/core/widgets.dart';

import 'package:ARMOYU/app/data/models/ARMOYU/country.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/job.dart' as armoyujob;
import 'package:ARMOYU/app/data/models/ARMOYU/province.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/team.dart';
import 'package:ARMOYU/app/data/models/select.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/country.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/country&province/province.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/team/team_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ARMOYUFunctions {
  final UserAccounts currentUserAccounts;

  ARMOYUFunctions({required this.currentUserAccounts});

  static User userfetch(APILogin response) {
    return User(
      userID: response.playerID,
      userName: Rx<String>(response.username!),
      firstName: Rx<String>(response.firstName!),
      lastName: Rx<String>(response.lastName!),
      displayName: Rx<String>(response.displayName!),
      userMail: Rx<String>(response.detailInfo!.email!),
      aboutme: Rx<String>(response.detailInfo!.about!),
      avatar: Media(
        mediaID: response.avatar!.mediaID,
        ownerID: response.playerID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.avatar!.mediaURL.bigURL),
          normalURL: Rx<String>(response.avatar!.mediaURL.normalURL),
          minURL: Rx<String>(response.avatar!.mediaURL.minURL),
        ),
      ),
      banner: Media(
        mediaID: response.banner!.mediaID,
        ownerID: response.playerID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.banner!.mediaURL.bigURL),
          normalURL: Rx<String>(response.banner!.mediaURL.normalURL),
          minURL: Rx<String>(response.banner!.mediaURL.minURL),
        ),
      ),
      burc: response.burc == null ? null : Rx<String>(response.burc!),
      invitecode: response.detailInfo!.inviteCode == null
          ? null
          : Rx<String>(response.detailInfo!.inviteCode!),
      lastlogin: response.detailInfo!.lastloginDate == null
          ? null
          : Rx<String>(response.detailInfo!.lastloginDate!),
      lastloginv2: response.detailInfo!.lastloginDateV2 == null
          ? null
          : Rx<String>(response.detailInfo!.lastloginDateV2!),
      lastfaillogin: response.detailInfo!.lastfailedDate == null
          ? null
          : Rx<String>(response.detailInfo!.lastfailedDate!),
      job: response.job == null
          ? null
          : armoyujob.Job(
              jobID: response.job!.jobID,
              name: response.job!.jobName,
              shortName: response.job!.jobShortName,
            ),
      level: Rx<int>(response.level!),
      levelColor: Rx<String>(response.levelColor!),
      xp: Rx<String>(response.levelXP!),
      awardsCount: response.detailInfo!.awards,
      postsCount: response.detailInfo!.posts,
      friendsCount: response.detailInfo!.friends,
      country: response.detailInfo!.country == null
          ? null
          : Country(
              countryID: response.detailInfo!.country!.countryID,
              name: response.detailInfo!.country!.name,
              countryCode: response.detailInfo!.country!.code,
              phoneCode: response.detailInfo!.country!.phonecode,
            ).obs,
      province: response.detailInfo!.province == null
          ? null
          : Province(
              provinceID: response.detailInfo!.province!.provinceID,
              name: response.detailInfo!.province!.name,
              plateCode: response.detailInfo!.province!.platecode,
              phoneCode: response.detailInfo!.province!.phonecode,
            ).obs,
      registerDate: response.registeredDateV2,
      role: Role(
        roleID: response.roleID!,
        name: response.roleName!,
        color: response.roleColor!,
      ),
      birthdayDate: Rxn<String>(response.detailInfo!.birthdayDate),
      phoneNumber: Rxn<String>(response.detailInfo!.phoneNumber),
      favTeam: response.favTeam != null
          ? Team(
              teamID: response.favTeam!.teamID,
              name: response.favTeam!.teamName,
              logo: response.favTeam!.teamLogo.minURL,
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
    ServiceResult response =
        await API.service.profileServices.selectfavteam(teamID: team?.teamID);
    log(response.toString());
    if (!response.status) {
      log(response.description);
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
      TeamListResponse response = await API.service.teamsServices.fetch();
      if (!response.result.status) {
        log(response.result.description);
        favteamfetch();
        return;
      }

      currentUserAccounts.favoriteteams = [];

      for (APITeamList element in response.response!) {
        currentUserAccounts.favoriteteams!.add(
          Team(
            teamID: element.teamId,
            name: element.teamName,
            logo: element.teamLogo.minURL,
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

  Future<void> fetchCountry() async {
    CountryResponse response = await API.service.countryServices.countryfetch();
    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    ARMOYU.countryList.clear();

    for (APICountry country in response.response!) {
      ARMOYU.countryList.add(
        Country(
          countryID: country.countryID,
          name: country.name,
          countryCode: country.code,
          phoneCode: country.phonecode,
        ),
      );

      if (currentUserAccounts.user.value.country != null) {
        if (country.countryID ==
            currentUserAccounts.user.value.country!.value.countryID) {
          fetchProvince(
            currentUserAccounts.user.value.country!.value.countryID,
            ARMOYU.countryList.length - 1,
          );
        }
      }
    }
  }

  Future<void> fetchProvince(int countryID, selectedIndex) async {
    if (ARMOYU.countryList[selectedIndex].provinceList != null) {
      if (ARMOYU.countryList[selectedIndex].provinceList!.isNotEmpty) {
        provinceSelectStatus.value = true;
      } else {
        provinceSelectStatus.value = false;
      }
      return;
    }

    ProvinceResponse response =
        await API.service.countryServices.fetchprovince(countryID: countryID);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    if (response.response == null) {
      provinceSelectStatus.value = false;
      return;
    }

    List<Province> provinceList = [];
    for (APIProvince province in response.response!) {
      log(province.name);
      provinceList.add(
        Province(
          provinceID: province.provinceID,
          name: province.name,
          plateCode: province.platecode,
          phoneCode: province.phonecode,
        ),
      );
    }

    ARMOYU.countryList.elementAt(selectedIndex).provinceList = provinceList;

    if (provinceList.isNotEmpty) {
      provinceSelectStatus.value = true;
    } else {
      provinceSelectStatus.value = false;
    }
  }

  static Rx<bool> provinceSelectStatus = false.obs;

  void profileEdit(BuildContext context) {
    FocusNode myFocusPassword = FocusNode();

    var firstName = TextEditingController().obs;
    firstName.value.text = currentUserAccounts.user.value.firstName.toString();

    var lastName = TextEditingController().obs;
    lastName.value.text = currentUserAccounts.user.value.lastName.toString();

    var aboutme = TextEditingController().obs;
    aboutme.value.text = currentUserAccounts.user.value.aboutme.toString();

    var email = TextEditingController().obs;
    email.value.text = currentUserAccounts.user.value.userMail.toString();

    var birthday = currentUserAccounts.user.value.birthdayDate;

    var country = (ProfileKeys.profileselectcountry.tr).obs;
    int? countryIndex = 0;

    if (currentUserAccounts.user.value.country != null) {
      country.value = currentUserAccounts.user.value.country!.value.name;
      countryIndex = currentUserAccounts.user.value.country!.value.countryID;
    }

    var province = (ProfileKeys.profileselectcity.tr).obs;
    int? provinceIndex = 0;
    if (currentUserAccounts.user.value.province != null) {
      province.value = currentUserAccounts.user.value.province!.value.name;
      provinceIndex = currentUserAccounts.user.value.province!.value.provinceID;
    }

    if (ARMOYU.countryList.isNotEmpty) {
      if (ARMOYU.countryList[countryIndex].provinceList != null) {
        provinceSelectStatus.value = true;
        // setstatefunction();
      }
    }
    Timer? searchTimer;

    if (ARMOYU.countryList.isEmpty) {
      fetchCountry();
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
                                  ProfileKeys.profilefirstname.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields.costum3(
                                  placeholder: currentUserAccounts
                                      .user.value.displayName!.value,
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
                                  ProfileKeys.profilelastname.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields.costum3(
                                  placeholder: currentUserAccounts
                                      .user.value.displayName!.value,
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
                                  ProfileKeys.profileaboutme.tr,
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
                                    ProfileKeys.profileemail.tr,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomTextfields.costum3(
                                  placeholder: currentUserAccounts
                                      .user.value.userMail!.value,
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
                                  ProfileKeys.profilelocation.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () => CustomButtons.costum1(
                                          text: country.value,
                                          onPressed: () {
                                            WidgetUtility.cupertinoselector(
                                              context: context,
                                              title: ProfileKeys
                                                  .profileselectcountry.tr,
                                              onChanged: (selectedIndex,
                                                  selectedValue) {
                                                if (selectedIndex == -1) {
                                                  return;
                                                }
                                                provinceSelectStatus.value =
                                                    false;
                                                province.value = ProfileKeys
                                                    .profileselectcity.tr;
                                                country.value = selectedValue;
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
                                                      countryID, selectedIndex);
                                                });
                                              },
                                              selectionList: Selection(
                                                list: ARMOYU.countryList
                                                    .map((country) {
                                                  return Select(
                                                    selectID: country.countryID,
                                                    title: country.name,
                                                    value: country.name,
                                                    selectionList: null,
                                                  );
                                                }).toList(),
                                              ).obs,
                                            );
                                          },
                                          loadingStatus: false.obs,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Obx(
                                        () => CustomButtons.costum1(
                                          text: province.value,
                                          enabled: provinceSelectStatus.value,
                                          onPressed: () {
                                            WidgetUtility.cupertinoselector(
                                              context: context,
                                              title: ProfileKeys
                                                  .profileselectcity.tr,
                                              onChanged: (selectedIndex,
                                                  selectedValue) {
                                                provinceIndex = selectedIndex;
                                                province.value = selectedValue;
                                              },

                                              selectionList: Selection(
                                                selectedIndex: Rxn(0),
                                                list: ARMOYU
                                                    .countryList[countryIndex!]
                                                    .provinceList!
                                                    .map((country) {
                                                  return Select(
                                                    selectID:
                                                        country.provinceID,
                                                    title: country.name,
                                                    value: country.name,
                                                    selectionList: null,
                                                  );
                                                }).toList(),
                                              ).obs,
                                              // list: ARMOYU
                                              //     .countryList[countryIndex!]
                                              //     .provinceList!
                                              //     .map((item) {
                                              //   return {
                                              //     item.provinceID:
                                              //         item.name.toString(),
                                              //   };
                                              // }).toList(),
                                            );
                                          },
                                          loadingStatus: false.obs,
                                        ),
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
                                  ProfileKeys.profilebirthdate.tr,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => CustomButtons.costum1(
                                    text: birthday!.value!,
                                    onPressed: () {
                                      WidgetUtility.cupertinoDatePicker(
                                        context: context,
                                        onChanged: (selectedValue) {
                                          birthday.value = selectedValue;
                                        },
                                      );
                                    },
                                    loadingStatus: false.obs,
                                  ),
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
                                  ProfileKeys.profilephonenumber.tr,
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
                                  ProfileKeys.profilecheckpassword.tr,
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
                          child: Obx(
                            () => CustomButtons.costum1(
                              text: CommonKeys.update.tr,
                              onPressed: () async {
                                if (passwordControl.value.text == "") {
                                  ARMOYUWidget.toastNotification(
                                      "Parola doğrulamasını yapınız!");

                                  myFocusPassword.requestFocus();
                                  return;
                                }

                                String cleanedphoneNumber = phoneNumber
                                    .value.text
                                    .replaceAll(RegExp(r'[()\s]'), '');

                                List<String> words =
                                    birthday!.value!.split(".");
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

                                if (profileeditProcess.value) {
                                  return;
                                }
                                profileeditProcess.value = true;
                                // setstatefunction();

                                ServiceResult response = await API
                                    .service.profileServices
                                    .saveprofiledetails(
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
                                // setstatefunction();
                                if (!response.status) {
                                  log(response.description);
                                  ARMOYUWidget.toastNotification(
                                    response.description,
                                  );
                                  return;
                                }
                                currentUserAccounts.user.value.firstName!
                                    .value = firstName.value.text;
                                currentUserAccounts.user.value.lastName!.value =
                                    lastName.value.text;
                                currentUserAccounts
                                        .user.value.displayName!.value =
                                    "${firstName.value.text} ${lastName.value.text}";

                                currentUserAccounts.user.value.aboutme!.value =
                                    aboutme.value.text;
                                currentUserAccounts.user.value.userMail =
                                    email.value.text.obs;
                                currentUserAccounts.user.value.country!.value =
                                    Country(
                                  countryID: int.parse(countryID),
                                  name: ARMOYU.countryList[countryIndex!].name,
                                  countryCode: ARMOYU
                                      .countryList[countryIndex!].countryCode,
                                  phoneCode: ARMOYU
                                      .countryList[countryIndex!].phoneCode,
                                );
                                currentUserAccounts.user.value.province =
                                    provinceID == ""
                                        ? null
                                        : Province(
                                            provinceID: int.parse(provinceID),
                                            name: ARMOYU
                                                .countryList[countryIndex!]
                                                .provinceList![provinceIndex!]
                                                .name,
                                            plateCode: ARMOYU
                                                .countryList[countryIndex!]
                                                .provinceList![provinceIndex!]
                                                .plateCode,
                                            phoneCode: ARMOYU
                                                .countryList[countryIndex!]
                                                .provinceList![provinceIndex!]
                                                .phoneCode,
                                          ).obs;
                                currentUserAccounts.user.value.phoneNumber!
                                    .value = cleanedphoneNumber;
                                currentUserAccounts.user.value.birthdayDate!
                                    .value = birthday.value;

                                ARMOYUWidget.toastNotification(
                                  response.description,
                                );
                                Get.back();
                              },
                              loadingStatus: profileeditProcess,
                            ),
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
