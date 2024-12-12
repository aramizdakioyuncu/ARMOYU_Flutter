import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

class StoryAPI {
  final User currentUser;
  StoryAPI({required this.currentUser});

  Future<StoryFetchListResponse> stories({required int page}) async {
    return await API.service.storyServices.stories(page: page);
  }

  Future<ServiceResult> addstory({
    required String imageURL,
    required bool isEveryonePublish,
  }) async {
    return await API.service.storyServices.addstory(
      imageURL: imageURL,
      isEveryonePublish: isEveryonePublish,
    );
  }

  Future<ServiceResult> removestory({required int storyID}) async {
    return await API.service.storyServices.removestory(storyID: storyID);
  }

  Future<ServiceResult> hidestory({required int storyID}) async {
    return await API.service.storyServices.hidestory(storyID: storyID);
  }

  Future<ServiceResult> view({required int storyID}) async {
    return await API.service.storyServices.view(storyID: storyID);
  }

  Future<StoryViewListResponse> fetchviewlist({required int storyID}) async {
    return await API.service.storyServices.fetchviewlist(storyID: storyID);
  }

  Future<ServiceResult> like({required int storyID}) async {
    return await API.service.storyServices.like(storyID: storyID);
  }

  Future<ServiceResult> likeremove({required int storyID}) async {
    return await API.service.storyServices.likeremove(storyID: storyID);
  }

  Future<StoryLikerListResponse> likerslist({required int storyID}) async {
    return await API.service.storyServices.likerslist(storyID: storyID);
  }
}
