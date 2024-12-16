import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/utils/newphotoviewer.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/detectabletext.dart';
import 'package:ARMOYU/app/widgets/posts/views/post_view.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/media/media_fetch.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart' as armoyumedia;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shimmer/shimmer.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ScrollController? scrollController;
  ProfileController({
    this.scrollController,
  });

  var ismyProfile = false.obs;
  late TabController tabController;

  late var profileScrollController = Rxn<ScrollController>();

  late Rxn<User> profileUser = Rxn<User>();

  var tabinitialIndex = 0.obs;

  var refreshprofilepageStatus = false.obs;
  var refreshprofilepageArrow = false.obs;

  var userProfile = User().obs;

  var isFriend = false.obs;

  var isbeFriend = false.obs;
  var listFriendTOP3 = [].obs;
  var friendTextLine = "".obs;

  var isAppBarExpanded = true.obs;
  var galleryproccess = false.obs;

  var friendStatus = "".obs;
  var friendStatuscolor = Colors.blue.obs;

  var postscounter = 1.obs;
  var postsfetchproccess = false.obs;

  var postscounterv2 = 1.obs;
  var postsfetchProccessv2 = false.obs;

  var gallerycounter = 1.obs;
  var firstgalleryfetcher = false.obs;

  var firstFetchPosts = true.obs;
  var firstFetchGallery = true.obs;
  var firstFetchTaggedPost = true.obs;

  var changeavatarStatus = false.obs;
  var changebannerStatus = false.obs;
  var scrollRefresh = ScrollController().obs;

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(user: User().obs, sessionTOKEN: Rx("")),
  );

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts = findCurrentAccountController.currentUserAccounts;
    if (scrollController != null) {
      profileScrollController.value = scrollController!;
    } else {
      profileScrollController.value = ScrollController();
    }

    tabController = TabController(
      initialIndex: tabinitialIndex.value,
      length: 3,
      vsync: this,
    );

    final Map<String, dynamic>? arguments = Get.arguments;

    ismyProfile = false.obs;

    if (arguments != null) {
      if (arguments['profileUser'] != null) {
        log("---başkası-----");
        profileUser.value = arguments['profileUser'];
        if (profileUser.value!.userID ==
            currentUserAccounts.value.user.value.userID) {
          ismyProfile.value = true;
        } else {
          ismyProfile.value = false;
        }
      } else {
        log("---ben-----");
        ismyProfile.value = true;
        profileUser.value = currentUserAccounts.value.user.value;
      }
    } else {
      log("---ben-----");
      ismyProfile.value = true;
      profileUser.value = currentUserAccounts.value.user.value;
    }

    test();

    scrollRefresh.value.addListener(() {
      // log(_scrollRefresh.position.pixels.toString());

      if (scrollRefresh.value.position.pixels <= -50) {
        refreshprofilepageArrow.value = false;

        if (!refreshprofilepageStatus.value) {
          handleRefresh(myProfileRefresh: true);

          refreshprofilepageStatus.value = true;
          //
        }
      }

      if (scrollRefresh.value.position.pixels < -10) {
        if (!refreshprofilepageStatus.value) {
          refreshprofilepageArrow.value = true;
        }
      }

      if (scrollRefresh.value.position.pixels == 0) {
        refreshprofilepageArrow.value = false;
      }
    });
  }

  Future<void> userblockingfunction() async {
    // Navigator.pop(Get.context);
    Get.back();

    BlockingAddResponse response = await API.service.blockingServices
        .add(userID: userProfile.value.userID!);

    ARMOYUWidget.toastNotification(response.result.description);

    if (!response.result.status) {
      log(response.result.description);
      return;
    }
  }

  var widgetPosts = Rxn<List>(null);
  var medialist = Rxn<List<Media>>(null);
  var widgetTaggedPosts = Rxn<List>(null);

  profileloadPosts(
      int page, int userID, Rxn<List<dynamic>> list, String category) async {
    if (postsfetchproccess.value) {
      return;
    }
    postsfetchproccess.value = true;

    FunctionService f = FunctionService();
    PostFetchListResponse response =
        await f.getprofilePosts(page, userID, category);
    if (!response.result.status) {
      log(response.result.description);

      postsfetchproccess.value = false;

      return;
    }

    list.value ??= [];

    if (response.response!.isEmpty) {
      postsfetchproccess.value = false;
      return;
    }
    for (APIPostList element in response.response!) {
      var media = <Media>[].obs;
      var comments = <Comment>[].obs;
      var likers = <Like>[].obs;

      if (element.media!.isNotEmpty) {
        for (armoyumedia.Media mediaInfo in element.media!) {
          media.add(
            Media(
              mediaID: mediaInfo.mediaID,
              ownerID: element.postOwner.ownerID,
              mediaType: mediaInfo.mediaType,
              mediaDirection: mediaInfo.mediaDirection,
              mediaURL: MediaURL(
                bigURL: Rx<String>(mediaInfo.mediaURL.bigURL),
                normalURL: Rx<String>(mediaInfo.mediaURL.normalURL),
                minURL: Rx<String>(mediaInfo.mediaURL.minURL),
              ),
            ),
          );
        }
      }

      for (APIPostLiker liker in element.firstlikers!) {
        likers.add(
          Like(
            likeID: liker.postlikeID,
            user: User(
              userID: liker.likerID,
              displayName: Rx<String>(liker.likerdisplayname),
              userName: Rx<String>(liker.likerusername),
              avatar: Media(
                mediaID: liker.likerID,
                mediaURL: MediaURL(
                  bigURL: Rx<String>(liker.likeravatar.bigURL),
                  normalURL: Rx<String>(liker.likeravatar.normalURL),
                  minURL: Rx<String>(liker.likeravatar.minURL),
                ),
              ),
            ),
            date: liker.likedate,
          ),
        );
      }

      for (var commenter in element.firstcomments!) {
        comments.add(
          Comment(
            commentID: commenter.commentID,
            postID: commenter.postID,
            user: User(
              userID: commenter.postcommenter.userID,
              displayName: Rx<String>(commenter.postcommenter.displayname),
              avatar: Media(
                mediaID: commenter.postcommenter.userID,
                mediaURL: MediaURL(
                  bigURL: Rx<String>(commenter.postcommenter.avatar.bigURL),
                  normalURL:
                      Rx<String>(commenter.postcommenter.avatar.normalURL),
                  minURL: Rx<String>(commenter.postcommenter.avatar.minURL),
                ),
              ),
            ),
            content: commenter.commentContent,
            likeCount: commenter.likeCount,
            didIlike: commenter.isLikedByMe ? true : false,
            date: commenter.commentElapsedTime,
          ),
        );
      }

      bool ismelike = false;
      if (element.didilikeit == 1) {
        ismelike = true;
      } else {
        ismelike = false;
      }
      bool ismecomment = false;

      if (element.didicommentit == 1) {
        ismecomment = true;
      } else {
        ismecomment = false;
      }
      Post post = Post(
        postID: element.postID,
        content: element.content,
        postDate: element.datecounting,
        sharedDevice: element.postdevice,
        likesCount: element.likeCount,
        isLikeme: ismelike,
        commentsCount: element.commentCount,
        iscommentMe: ismecomment,
        media: media,
        owner: User(
          userID: element.postOwner.ownerID,
          userName: Rx<String>(element.postOwner.displayName),
          avatar: Media(
            mediaID: element.postOwner.ownerID,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.postOwner.avatar.bigURL),
              normalURL: Rx<String>(element.postOwner.avatar.normalURL),
              minURL: Rx<String>(element.postOwner.avatar.minURL),
            ),
          ),
        ),
        firstthreecomment: comments,
        firstthreelike: likers,
        location: element.location,
      );

      list.value!.add(
        TwitterPostWidget(
          currentUserAccounts: currentUserAccounts.value,
          post: post,
        ),
      );
    }
    postscounter++;
    postsfetchproccess.value = false;
  }

  gallery(int page, int userID) async {
    firstgalleryfetcher.value = true;

    if (galleryproccess.value) {
      return;
    }

    galleryproccess.value = true;

    MediaFetchResponse response = await API.service.mediaServices
        .fetch(uyeID: userID, category: "-1", page: page);

    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    medialist.value ??= [];

    if (response.response!.isEmpty) {
      log("Sayfa Sonu");
      galleryproccess.value = false;
      return;
    }

    if (page == 1) {
      medialist.value = [];
    }

    for (APIMediaFetch element in response.response!) {
      medialist.value!.add(
        Media(
          mediaID: element.media.mediaID,
          ownerID: element.mediaOwner.userID,
          ownerusername: element.mediaOwner.displayname,
          owneravatar: element.mediaOwner.avatar.minURL,
          mediaTime: element.mediaDate,
          mediaType: element.mediatype,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.media.mediaURL.bigURL),
            normalURL: Rx<String>(element.media.mediaURL.normalURL),
            minURL: Rx<String>(element.media.mediaURL.minURL),
          ),
        ),
      );
    }
    galleryproccess.value = false;
    gallerycounter++;
  }

  profileloadtaggedPosts(
      int page, int userID, Rxn<List<dynamic>> list, String category) async {
    if (postsfetchProccessv2.value) {
      return;
    }

    postsfetchProccessv2.value = true;

    FunctionService f = FunctionService();
    PostFetchListResponse response =
        await f.getprofilePosts(page, userID, category);
    if (!response.result.status) {
      log(response.result.description);
      postsfetchProccessv2.value = false;
      return;
    }

    list.value ??= [];

    if (response.response!.isEmpty) {
      postsfetchproccess.value = false;
      return;
    }
    for (APIPostList element in response.response!) {
      var media = <Media>[].obs;
      var comments = <Comment>[].obs;
      var likers = <Like>[].obs;

      if (element.media!.isNotEmpty) {
        for (armoyumedia.Media mediaInfo in element.media!) {
          media.add(
            Media(
              mediaID: mediaInfo.mediaID,
              ownerID: element.postOwner.ownerID,
              mediaType: mediaInfo.mediaType,
              mediaDirection: mediaInfo.mediaDirection,
              mediaURL: MediaURL(
                bigURL: Rx<String>(mediaInfo.mediaURL.bigURL),
                normalURL: Rx<String>(mediaInfo.mediaURL.normalURL),
                minURL: Rx<String>(mediaInfo.mediaURL.minURL),
              ),
            ),
          );
        }
      }

      for (APIPostLiker liker in element.firstlikers!) {
        likers.add(
          Like(
            likeID: liker.postlikeID,
            user: User(
              userID: liker.likerID,
              displayName: Rx<String>(liker.likerdisplayname),
              userName: Rx<String>(liker.likerusername),
              avatar: Media(
                mediaID: liker.likerID,
                mediaURL: MediaURL(
                  bigURL: Rx<String>(liker.likeravatar.bigURL),
                  normalURL: Rx<String>(liker.likeravatar.normalURL),
                  minURL: Rx<String>(liker.likeravatar.minURL),
                ),
              ),
            ),
            date: liker.likedate,
          ),
        );
      }

      for (var commenter in element.firstcomments!) {
        comments.add(
          Comment(
            commentID: commenter.commentID,
            postID: commenter.postID,
            user: User(
              userID: commenter.postcommenter.userID,
              displayName: Rx<String>(commenter.postcommenter.displayname),
              avatar: Media(
                mediaID: commenter.postcommenter.userID,
                mediaURL: MediaURL(
                  bigURL: Rx<String>(commenter.postcommenter.avatar.bigURL),
                  normalURL:
                      Rx<String>(commenter.postcommenter.avatar.normalURL),
                  minURL: Rx<String>(commenter.postcommenter.avatar.minURL),
                ),
              ),
            ),
            content: commenter.commentContent,
            likeCount: commenter.likeCount,
            didIlike: commenter.isLikedByMe ? true : false,
            date: commenter.commentElapsedTime,
          ),
        );
      }

      bool ismelike = false;
      if (element.didilikeit == 1) {
        ismelike = true;
      } else {
        ismelike = false;
      }
      bool ismecomment = false;

      if (element.didicommentit == 1) {
        ismecomment = true;
      } else {
        ismecomment = false;
      }
      Post post = Post(
        postID: element.postID,
        content: element.content,
        postDate: element.datecounting,
        sharedDevice: element.postdevice,
        likesCount: element.likeCount,
        isLikeme: ismelike,
        commentsCount: element.commentCount,
        iscommentMe: ismecomment,
        media: media,
        owner: User(
          userID: element.postOwner.ownerID,
          userName: Rx<String>(element.postOwner.displayName),
          avatar: Media(
            mediaID: element.postOwner.ownerID,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.postOwner.avatar.bigURL),
              normalURL: Rx<String>(element.postOwner.avatar.normalURL),
              minURL: Rx<String>(element.postOwner.avatar.minURL),
            ),
          ),
        ),
        firstthreecomment: comments,
        firstthreelike: likers,
        location: element.location,
      );

      list.value!.add(
        TwitterPostWidget(
          currentUserAccounts: currentUserAccounts.value,
          post: post,
        ),
      );
    }
    postscounterv2++;
    postsfetchProccessv2.value = false;
  }

  Future<void> test({bool myprofilerefresh = false}) async {
    log("----${profileUser.value!.userID == currentUserAccounts.value.user.value.userID}-----");
    if (profileUser.value!.userID ==
        currentUserAccounts.value.user.value.userID) {
      if (myprofilerefresh) {
        FunctionService f = FunctionService();

        LookProfileResponse response =
            await f.lookProfile(currentUserAccounts.value.user.value.userID!);

        if (!response.result.status) {
          log("Oyuncu bulunamadı");
          return;
          // test();
        }

        userProfile.value = ARMOYUFunctions.userfetch(response.response!);
      } else {
        userProfile.value = currentUserAccounts.value.user.value;
      }
    } else {
      LookProfileResponse response;
      if (profileUser.value!.userName != null) {
        log("->>kullanıcıadına  göre oyuncu bul!");

        FunctionService f = FunctionService();

        LookProfilewithUsernameResponse response =
            await f.lookProfilewithusername(profileUser.value!.userName!.value);

        if (!response.result.status) {
          log("Oyuncu bulunamadı");
          return;
        }

        if (response.result.description == "Oyuncu bilgileri yanlış!") {
          return;
        }
        //Kullanıcı adında birisi var
        APILogin oyuncubilgi = response.response!;

        userProfile.value = ARMOYUFunctions.userfetch(oyuncubilgi);

        if (oyuncubilgi.arkadasdurum == "1") {
          isFriend.value = true;
          isbeFriend.value = false;
        } else if (oyuncubilgi.arkadasdurum == "2") {
          isFriend.value = false;
          isbeFriend.value = false;
        } else {
          isFriend.value = false;
          isbeFriend.value = true;
        }
        listFriendTOP3.clear();
        friendTextLine.value = "";

        int countorder = 0;

        for (Friend userfriendSummary in oyuncubilgi.ortakarkadasliste!) {
          if (countorder < 2) {
            if (countorder == 0) {
              friendTextLine.value +=
                  "@${userfriendSummary.oyuncuKullaniciAdi} ";
            } else {
              if (oyuncubilgi.ortakarkadasliste!.length == 2) {
                friendTextLine.value +=
                    "ve @${userfriendSummary.oyuncuKullaniciAdi} ";
              } else {
                friendTextLine.value +=
                    ", @${userfriendSummary.oyuncuKullaniciAdi} ";
              }
            }
          }
          listFriendTOP3.add(userfriendSummary.oyuncuMinnakAvatar.minURL);

          countorder++;
        }

        if (oyuncubilgi.ortakarkadasliste!.length > 2) {
          int mutualFriend = oyuncubilgi.ortakarkadaslar! - 2;
          friendTextLine.value +=
              "ve ${mutualFriend.toString()} diğer kişi ile arkadaş";
        } else if (oyuncubilgi.ortakarkadasliste!.length == 2) {
          friendTextLine.value += " ile arkadaş";
        } else if (oyuncubilgi.ortakarkadasliste!.length == 1) {
          friendTextLine.value += " ile arkadaş";
        }
        ///////
      } else {
        log("->>ID ye göre oyuncu bul!");
        FunctionService f = FunctionService();
        response = await f.lookProfile(profileUser.value!.userID!);
        if (!response.result.status) {
          log("Oyuncu bulunamadı");
          return;
        }

        APILogin oyuncubilgi = response.response!;

        userProfile.value = ARMOYUFunctions.userfetch(oyuncubilgi);

        if (oyuncubilgi.arkadasdurum == "1") {
          isFriend.value = true;
          isbeFriend.value = false;
        } else if (oyuncubilgi.arkadasdurum == "2") {
          isFriend.value = false;
          isbeFriend.value = false;
        } else {
          isFriend.value = false;
          isbeFriend.value = true;
        }

        listFriendTOP3.clear();
        friendTextLine.value = "";
        int countorder = 0;

        for (Friend userfriendSummary in oyuncubilgi.ortakarkadasliste!) {
          if (countorder < 2) {
            if (countorder == 0) {
              friendTextLine.value +=
                  "@${userfriendSummary.oyuncuKullaniciAdi} ";
            } else {
              if (oyuncubilgi.ortakarkadasliste!.length == 2) {
                friendTextLine.value +=
                    "ve @${userfriendSummary.oyuncuKullaniciAdi} ";
              } else {
                friendTextLine.value +=
                    ", @${userfriendSummary.oyuncuKullaniciAdi} ";
              }
            }
          }
          listFriendTOP3.add(userfriendSummary.oyuncuMinnakAvatar.minURL);

          countorder++;
        }

        if (oyuncubilgi.ortakarkadasliste!.length > 2) {
          int mutualFriend = oyuncubilgi.ortakarkadaslar! - 2;
          friendTextLine.value +=
              "ve ${mutualFriend.toString()} diğer kişi ile arkadaş";
        } else if (oyuncubilgi.ortakarkadasliste!.length == 2) {
          friendTextLine.value += " ile arkadaş";
        } else if (oyuncubilgi.ortakarkadasliste!.length == 1) {
          friendTextLine.value += " ile arkadaş";
        }
        /////
      }

      if (isbeFriend.value && !isFriend.value && !ismyProfile.value) {
        friendStatus.value = "Arkadaş Ol";
        friendStatuscolor.value = Colors.blue;
      } else if (!isbeFriend.value && !isFriend.value && !ismyProfile.value) {
        friendStatus.value = "İstek Gönderildi";
        friendStatuscolor.value = Colors.green;
      } else if (!isbeFriend.value && isFriend.value && !ismyProfile.value) {
        friendStatus.value = "Mesaj Gönder";
        friendStatuscolor.value = Colors.blue;
      }
    }

    log("yeniden veriler çekiliyor");

    if (firstFetchPosts.value || myprofilerefresh) {
      if (myprofilerefresh) {
        postscounter.value = 1;
      }
      profileloadPosts(
        postscounter.value,
        userProfile.value.userID!,
        widgetPosts,
        "",
      );
      firstFetchPosts.value = false;
    }
    if (firstFetchGallery.value || myprofilerefresh) {
      if (myprofilerefresh) {
        gallerycounter.value = 1;
      }
      gallery(
        gallerycounter.value,
        userProfile.value.userID!,
      );

      firstFetchGallery.value = false;
    }

    if (firstFetchTaggedPost.value || myprofilerefresh) {
      if (myprofilerefresh) {
        postscounterv2.value = 1;
      }
      profileloadtaggedPosts(
        postscounterv2.value,
        userProfile.value.userID!,
        widgetTaggedPosts,
        "etiketlenmis",
      );
      firstFetchTaggedPost.value = false;
    }

    refreshprofilepageStatus.value = false;
  }

  Future<void> handleRefresh({bool myProfileRefresh = false}) async {
    refreshprofilepageStatus.value = true;

    log("--BAŞLADI---");

    await test(myprofilerefresh: myProfileRefresh);
    log("---BİTTİ--");
    refreshprofilepageStatus.value = false;
  }

  Future<void> defaultavatar() async {
    // Navigator.pop(context);
    Get.back();

    if (changeavatarStatus.value) {
      return;
    }

    changeavatarStatus.value = true;

    ServiceResult response = await API.service.profileServices.defaultavatar();
    if (!response.status) {
      log(response.description);
      ARMOYUWidget.toastNotification(response.description);
      changeavatarStatus.value = false;

      return;
    }

    currentUserAccounts.value.user.value.avatar = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.descriptiondetail.toString()),
        normalURL: Rx<String>(response.descriptiondetail.toString()),
        minURL: Rx<String>(response.descriptiondetail.toString()),
      ),
    );

    userProfile.value.avatar = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.descriptiondetail.toString()),
        normalURL: Rx<String>(response.descriptiondetail.toString()),
        minURL: Rx<String>(response.descriptiondetail.toString()),
      ),
    );

    changeavatarStatus.value = false;
  }

  Future<void> defaultbanner() async {
    // Navigator.pop(context);
    Get.back();

    if (changebannerStatus.value) {
      return;
    }

    changebannerStatus.value = true;

    ServiceResult response = await API.service.profileServices.defaultavatar();
    if (!response.status) {
      log(response.description);
      ARMOYUWidget.toastNotification(response.description);
      changebannerStatus.value = false;

      return;
    }

    currentUserAccounts.value.user.value.banner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.descriptiondetail.toString()),
        normalURL: Rx<String>(response.descriptiondetail.toString()),
        minURL: Rx<String>(response.descriptiondetail.toString()),
      ),
    );

    userProfile.value.banner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.descriptiondetail.toString()),
        normalURL: Rx<String>(response.descriptiondetail.toString()),
        minURL: Rx<String>(response.descriptiondetail.toString()),
      ),
    );

    changebannerStatus.value = false;
  }

  Future<void> changeavatar() async {
    // Navigator.pop(context);
    Get.back();

    if (changeavatarStatus.value) {
      ARMOYUWidget.toastNotification("Lütfen görselin yüklenmesini bekleyin!");
      return;
    }

    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.square,
    );
    if (selectedImage == null) {
      return;
    }

    changeavatarStatus.value = true;

    List<XFile> imagePath = [];
    imagePath.add(selectedImage);
    ServiceResult response =
        await API.service.profileServices.changeavatar(files: imagePath);
    if (!response.status) {
      log(response.description);
      ARMOYUWidget.toastNotification(response.description);
      changeavatarStatus.value = false;

      return;
    }

    currentUserAccounts.value.user.value.avatar = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.descriptiondetail.toString()),
        normalURL: Rx<String>(response.descriptiondetail.toString()),
        minURL: Rx<String>(response.descriptiondetail.toString()),
      ),
    );
    changeavatarStatus.value = false;

    await handleRefresh();
  }

  Future<void> changebanner() async {
    // Navigator.pop(context);
    Get.back();

    if (changebannerStatus.value) {
      ARMOYUWidget.toastNotification(
          "Lütfen arkaplan görselinin yüklenmesini bekleyin!");
      return;
    }
    XFile? selectedImage = await AppCore.pickImage(
      willbeCrop: true,
      cropsquare: CropAspectRatioPreset.ratio16x9,
    );
    if (selectedImage == null) {
      return;
    }

    changebannerStatus.value = true;

    List<XFile> imagePath = [];
    imagePath.add(selectedImage);
    ServiceResult response =
        await API.service.profileServices.changebanner(files: imagePath);
    if (!response.status) {
      log(response.description);
      ARMOYUWidget.toastNotification(response.description);

      changebannerStatus.value = false;

      return;
    }
    currentUserAccounts.value.user.value.banner = Media(
      mediaID: 1000000,
      mediaURL: MediaURL(
        bigURL: Rx<String>(response.descriptiondetail.toString()),
        normalURL: Rx<String>(response.descriptiondetail.toString()),
        minURL: Rx<String>(response.descriptiondetail.toString()),
      ),
    );

    changebannerStatus.value = false;

    await handleRefresh();
  }

  Future<void> friendrequest() async {
    ServiceResult response = await API.service.profileServices
        .friendrequest(userID: userProfile.value.userID!);

    if (!response.status) {
      log(response.description);
      return;
    }

    friendStatus.value = "Bekleniyor";
    friendStatuscolor.value = Colors.green;
  }

  Future<void> cancelfriendrequest() async {
    log("istek iptal edilecek ");
  }

  Widget widgetFriendList(bool isclip, double left, String imageUrl) {
    if (isclip) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: 25,
            height: 25,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }
    return Positioned(
      left: left,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: 25,
          height: 25,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  bool handleScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      final metrics = scrollNotification.metrics;

      if (metrics.atEdge && metrics.pixels >= metrics.maxScrollExtent * 0.5) {
        log("------Paylaşım------");
        profileloadPosts(
            postscounter.value, userProfile.value.userID!, widgetPosts, "");
        return true;
      }
    }
    return false;
  }

  Widget buildPostList() {
    return firstFetchPosts.value || widgetPosts.value == null
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : widgetPosts.value!.isEmpty
            ? Center(
                child: Text(CommonKeys.empty.tr),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: handleScrollNotification,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  key: const PageStorageKey('Tab1'),
                  shrinkWrap: true,
                  children: [
                    ...List.generate(
                      widgetPosts.value!.length,
                      (index) => widgetPosts.value![index],
                    ),
                    Visibility(
                      visible: postsfetchproccess.value,
                      child: const SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ],
                ),
              );
  }

  bool handleScrollNotificationGallery(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      final metrics = scrollNotification.metrics;
      if (metrics.atEdge && metrics.pixels >= metrics.maxScrollExtent * 0.5) {
        log("------Galeri------");
        gallery(gallerycounter.value, userProfile.value.userID!);
        return true;
      }
    }
    return false;
  }

  Widget buildGallery() {
    return firstFetchGallery.value || medialist.value == null
        ? const Center(child: CupertinoActivityIndicator())
        : medialist.value!.isEmpty
            ? const Center(
                child: Text("Boş"),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: handleScrollNotificationGallery,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  key: const PageStorageKey('Tab2'),
                  shrinkWrap: true,
                  children: [
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      children: List.generate(
                        medialist.value!.length,
                        (index) => medialist.value![index].mediaGallery(
                          currentUser: userProfile.value,
                          context: Get.context!,
                          index: index,
                          medialist: medialist.value!,
                          setstatefunction: () {},
                        ),
                      ),
                    ),
                    Visibility(
                      visible: galleryproccess.value,
                      child: const SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  ],
                ),
              );
  }

  bool handleScrollNotificationTagged(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      final metrics = scrollNotification.metrics;
      if (metrics.atEdge && metrics.pixels >= metrics.maxScrollExtent * 0.5) {
        log("------Paylaşım Etiketlenmiş------");
        profileloadtaggedPosts(
          postscounterv2.value,
          userProfile.value.userID!,
          widgetTaggedPosts,
          "etiketlenmis",
        );
        return true;
      }
    }
    return false;
  }

  Widget buildTaggedPosts() {
    return firstFetchTaggedPost.value || widgetTaggedPosts.value == null
        ? const Center(child: CupertinoActivityIndicator())
        : widgetTaggedPosts.value!.isEmpty
            ? Center(
                child: Text(CommonKeys.empty.tr),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: handleScrollNotificationTagged,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  key: const PageStorageKey('Tab3'),
                  shrinkWrap: true,
                  children: [
                    ...List.generate(
                      widgetTaggedPosts.value!.length,
                      (index) => widgetTaggedPosts.value![index],
                    ),
                  ],
                ),
              );
  }

  ///WidgetsProfile
  ///
  Widget buildProfileAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (userProfile.value.avatar == null) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MediaViewer(
              currentUser: currentUserAccounts.value.user.value,
              media: [userProfile.value.avatar!],
              initialIndex: 0,
            ),
          ),
        );
      },
      onLongPress: () {
        if (!ismyProfile.value) {
          return;
        }
        showModalBottomSheet<void>(
          backgroundColor: Get.theme.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          width: ARMOYU.screenWidth / 4,
                          height: 5,
                        ),
                      ),
                      Visibility(
                        visible: ismyProfile.value,
                        child: InkWell(
                          onTap: () async => await changeavatar(),
                          child: const ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text("Avatar değiştir."),
                          ),
                        ),
                      ),
                      const Divider(),
                      Visibility(
                        visible: ismyProfile.value,
                        child: InkWell(
                          onTap: () async => await defaultavatar(),
                          child: const ListTile(
                            textColor: Colors.red,
                            leading: Icon(Icons.person_off_outlined,
                                color: Colors.red),
                            title: Text("Varsayılana dönder."),
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
      child: userProfile.value.avatar == null
          ? Shimmer.fromColors(
              baseColor: Get.theme.disabledColor,
              highlightColor: Get.theme.highlightColor,
              child: const CircleAvatar(
                  radius: 50.0, backgroundColor: Colors.white),
            )
          : buildAvatarImage(),
    );
  }

  ///// Profil avatarını oluşturan bileşen
  Widget buildAvatarImage() {
    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(int.parse("0xFF${userProfile.value.levelColor}")),
                width: 4,
              ),
              image: changeavatarStatus.value
                  ? null
                  : DecorationImage(
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      image: CachedNetworkImageProvider(
                        userProfile.value.avatar!.mediaURL.minURL.value,
                      ),
                    ),
            ),
            child: Stack(
              children: [
                if (changeavatarStatus.value)
                  const CupertinoActivityIndicator(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse("0xFF${userProfile.value.levelColor}")),
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(100, 100)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        userProfile.value.level.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),
        if (userProfile.value.xp == null)
          Shimmer.fromColors(
            baseColor: Get.theme.disabledColor,
            highlightColor: Get.theme.highlightColor,
            child: const SizedBox(width: 200),
          )
        else
          CustomText.costum1("${userProfile.value.xp} XP",
              weight: FontWeight.bold),
      ],
    );
  }

  // Banner widget'ını oluşturan fonksiyon
  Widget buildBannerWidget(BuildContext context) {
    if (userProfile.value.banner == null) return Container();

    return Container(
      height: ARMOYU.screenHeight * 0.25,
      width: ARMOYU.screenWidth,
      decoration: BoxDecoration(
        image: changeavatarStatus.value
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                colorFilter: refreshprofilepageStatus.value
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.8),
                        BlendMode.darken,
                      )
                    : ColorFilter.mode(
                        Colors.black.withOpacity(0.0),
                        BlendMode.darken,
                      ),
                image: CachedNetworkImageProvider(
                  userProfile.value.banner!.mediaURL.minURL.value,
                ),
              ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollRefresh.value,
        child: Stack(
          children: [
            SizedBox(
              height: ARMOYU.screenHeight * 0.25,
              width: ARMOYU.screenWidth,
              child: changebannerStatus.value
                  ? const CupertinoActivityIndicator()
                  : null,
            ),
            SizedBox(
              height: ARMOYU.screenHeight * 0.25,
              width: ARMOYU.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: refreshprofilepageStatus.value,
                    child: const CupertinoActivityIndicator(),
                  ),
                  Visibility(
                    visible: refreshprofilepageStatus.value,
                    child: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kullanıcı gönderi sayısını kontrol eden fonksiyon
  Widget getPostsCountWidget() {
    if (userProfile.value.postsCount == null) {
      return Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: const SizedBox(width: 35, height: 30),
      );
    } else {
      return Column(
        children: [
          CustomText.costum1(userProfile.value.postsCount.toString(),
              weight: FontWeight.bold),
          CustomText.costum1(ProfileKeys.profilePost.tr),
        ],
      );
    }
  }

  // Kullanıcı arkadaş sayısını kontrol eden fonksiyon
  Widget getFriendsCountWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (userProfile.value.friendsCount == null) {
          return;
        }

        Get.toNamed("profile/friendlist", arguments: {
          "user":
              UserAccounts(user: userProfile.value.obs, sessionTOKEN: Rx("")),
        });
      },
      child: userProfile.value.friendsCount == null
          ? Shimmer.fromColors(
              baseColor: Get.theme.disabledColor,
              highlightColor: Get.theme.highlightColor,
              child: const SizedBox(width: 35, height: 30),
            )
          : Column(
              children: [
                CustomText.costum1(userProfile.value.friendsCount.toString(),
                    weight: FontWeight.bold),
                CustomText.costum1(ProfileKeys.profilefriend.tr),
              ],
            ),
    );
  }

  // Kullanıcı ödül sayısını kontrol eden fonksiyon
  Widget getAwardsCountWidget() {
    if (userProfile.value.awardsCount == null) {
      return Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: Container(
          width: 35,
          height: 30,
          padding: const EdgeInsets.all(2),
        ),
      );
    } else {
      return Column(
        children: [
          CustomText.costum1(userProfile.value.awardsCount.toString(),
              weight: FontWeight.bold),
          CustomText.costum1(ProfileKeys.profileaward.tr),
        ],
      );
    }
  }

  // Kullanıcı favori takımını kontrol eden fonksiyon
  Widget getFavTeamWidget(BuildContext context) {
    if (userProfile.value.favTeam == null) {
      return const Column();
    } else {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              if (!ismyProfile.value) {
                return;
              }
              ARMOYUFunctions functions = ARMOYUFunctions(
                currentUserAccounts: currentUserAccounts.value,
              );
              functions.selectFavTeam(context, force: true);
            },
            child: CachedNetworkImage(
              imageUrl: userProfile.value.favTeam!.logo,
              height: 40,
              width: 40,
            ),
          ),
        ],
      );
    }
  }

  // Kullanıcının adını kontrol eden fonksiyon
  Widget getDisplayNameWidget() {
    if (userProfile.value.displayName == null) {
      return Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: Container(
          width: 50.0,
          padding: const EdgeInsets.all(5),
        ),
      );
    } else {
      return CustomText.costum1(
        userProfile.value.displayName!.value,
        size: 16,
        weight: FontWeight.bold,
      );
    }
  }

  // Kullanıcı adını kontrol eden fonksiyon
  Widget getUserNameWidget() {
    if (userProfile.value.userName == null) {
      return Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(5),
        ),
      );
    } else {
      return CustomText.costum1(
        "@${userProfile.value.userName}",
      );
    }
  }

  // Kullanıcı rolünü kontrol eden fonksiyon
  Widget getUserRoleWidget() {
    if (userProfile.value.role == null) {
      return Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: const SizedBox(
          width: 20,
        ),
      );
    } else {
      return Text(
        userProfile.value.role!.name,
        style: TextStyle(
          color: Color(
            int.parse(
              "0xFF${userProfile.value.role!.color}",
            ),
          ),
        ),
      );
    }
  }

  // Kayıt tarihini kontrol eden fonksiyon
  Widget getRegisterDateWidget() {
    if (userProfile.value.registerDate == null) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(
          Icons.calendar_month,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 3),
        CustomText.costum1(userProfile.value.registerDate!),
      ],
    );
  }

  // Burcu kontrol eden fonksiyon
  Widget getBurcWidget() {
    if (userProfile.value.burc == null) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(
          Icons.window,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 3),
        CustomText.costum1(userProfile.value.burc!.value),
      ],
    );
  }

  // Ülke ve il bilgisini kontrol eden fonksiyon
  Widget getCountryAndProvinceWidget() {
    if (userProfile.value.country == null) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 3),
        Row(
          children: [
            CustomText.costum1("${userProfile.value.country?.value.name}"),
            const SizedBox(width: 5),
            userProfile.value.province == null
                ? Container()
                : CustomText.costum1(
                    "${userProfile.value.province?.value.name}"),
          ],
        ),
      ],
    );
  }

  // Meslek bilgisini kontrol eden fonksiyon
  Widget getJobWidget() {
    if (userProfile.value.job == null) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(
          Icons.school,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 3),
        CustomText.costum1(userProfile.value.job!.name),
      ],
    );
  }

  // Arkadaş listesi widget'ını oluşturan fonksiyon
  Widget getFriendListWidget(BuildContext context) {
    if (ismyProfile.value || listFriendTOP3.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Stack(
          children: [
            ...List.generate(listFriendTOP3.length, (index) {
              final reversedIndex = listFriendTOP3.length - 1 - index;
              return widgetFriendList(
                reversedIndex == 0,
                reversedIndex * 15,
                listFriendTOP3[reversedIndex].toString(),
              );
            }),
            SizedBox(
              width: listFriendTOP3.length * 65 / 3,
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              WidgetUtility.specialText(
                context,
                currentUserAccounts: currentUserAccounts.value,
                friendTextLine.value,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Geri butonu widget'ını oluşturan fonksiyon
  Widget buildLeadingWidget(BuildContext context) {
    if (ismyProfile.value) {
      return Container();
    } else {
      return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded),
      );
    }
  }

  // Başlık widget'ını oluşturan fonksiyon
  Widget buildTitleWidget() {
    if (ismyProfile.value) {
      return Container();
    } else if (userProfile.value.displayName == null) {
      return Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: Container(width: 200),
      );
    } else {
      return Text(
        userProfile.value.displayName.toString(),
      );
    }
  }

  // Arkadaş ol butonunu oluşturan fonksiyon
  Widget buildFriendButton(BuildContext context) {
    if (isbeFriend.value && !isFriend.value && !ismyProfile.value) {
      return Expanded(
        child: CustomButtons.friendbuttons(
          friendStatus.value,
          friendrequest,
          friendStatuscolor.value,
        ),
      );
    }
    return const SizedBox.shrink(); // Eğer görünmüyorsa boş bir widget döndür
  }

  // İstek gönderildi butonunu oluşturan fonksiyon
  Widget buildFriendRequestButton(BuildContext context) {
    if (!isbeFriend.value &&
        !isFriend.value &&
        !ismyProfile.value &&
        userProfile.value.userID != -1) {
      if (friendStatus.value == "") {
        return Expanded(
          child: Shimmer.fromColors(
            baseColor: Get.theme.disabledColor,
            highlightColor: Get.theme.highlightColor,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(""),
            ),
          ),
        );
      } else {
        return Expanded(
          child: CustomButtons.friendbuttons(
            friendStatus.value,
            cancelfriendrequest,
            friendStatuscolor.value,
          ),
        );
      }
    }
    return const SizedBox.shrink(); // Eğer görünmüyorsa boş bir widget döndür
  }

  // Mesaj gönder butonunu oluşturan fonksiyon
  Widget buildMessageButton(BuildContext context) {
    if (!isbeFriend.value && isFriend.value && !ismyProfile.value) {
      return Expanded(
        child: Chat(
          user: userProfile.value,
          chatNotification: false.obs,
        ).profilesendMessage(
          context,
          currentUserAccounts: currentUserAccounts.value,
        ),
      );
    }
    return const SizedBox.shrink(); // Eğer görünmüyorsa boş bir widget döndür
  }

  // Hakkımda metnini oluşturan fonksiyon
  Widget buildAboutMeSection(BuildContext context) {
    if (userProfile.value.aboutme?.isEmpty ?? true) {
      return const SizedBox.shrink(); // Eğer boşsa boş bir widget döndür
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userProfile.value.aboutme == null
            ? Shimmer.fromColors(
                baseColor: Get.theme.disabledColor,
                highlightColor: Get.theme.highlightColor,
                child: const SizedBox(
                  width: 350,
                ),
              )
            : CustomDedectabletext.costum1(
                userProfile.value.aboutme!.value,
                3,
                13,
              ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Modal Bottom Sheet gösteren fonksiyon
  void showProfileActions(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      backgroundColor: Get.theme.cardColor,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      width: ARMOYU.screenWidth / 4,
                      height: 5,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: Text(ProfileKeys.profilerefresh.tr),
                    onTap: () async {
                      Navigator.pop(context);
                      await handleRefresh(myProfileRefresh: true);
                    },
                  ),
                  Visibility(
                    visible: ismyProfile.value,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ARMOYUFunctions functions = ARMOYUFunctions(
                          currentUserAccounts: currentUserAccounts.value,
                        );
                        functions.profileEdit(context);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(ProfileKeys.profileEdit.tr),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(Icons.content_copy),
                      title: Text(ProfileKeys.profilecopylink.tr),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: !ismyProfile.value,
                    child: InkWell(
                      onTap: () => userblockingfunction(),
                      child: ListTile(
                        textColor: Colors.red,
                        leading: const Icon(
                          Icons.person_off_outlined,
                          color: Colors.red,
                        ),
                        title: Text(ProfileKeys.profileblock.tr),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !ismyProfile.value,
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        textColor: Colors.red,
                        leading: const Icon(
                          Icons.flag_outlined,
                          color: Colors.red,
                        ),
                        title: Text(ProfileKeys.profilereport.tr),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isFriend.value,
                    child: InkWell(
                      onTap: () async {
                        ServiceResult response =
                            await API.service.profileServices.friendremove(
                          userID: userProfile.value.userID!,
                        );
                        if (!response.status) {
                          log(response.description);
                          return;
                        }
                      },
                      child: ListTile(
                        textColor: Colors.red,
                        leading: const Icon(
                          Icons.person_remove,
                          color: Colors.pink,
                        ),
                        title: Text(ProfileKeys.profileremovefriend.tr),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isFriend.value,
                    child: InkWell(
                      onTap: () async {
                        ServiceResult response =
                            await API.service.profileServices.userdurting(
                          userID: userProfile.value.userID!,
                        );
                        if (!response.status) {
                          log(response.description);
                          ARMOYUWidget.toastNotification(
                              response.description.toString());
                          return;
                        }
                      },
                      child: ListTile(
                        textColor: Colors.orange,
                        leading: const Icon(
                          Icons.local_fire_department,
                          color: Colors.pink,
                        ),
                        title: Text(ProfileKeys.profilepoke.tr),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
