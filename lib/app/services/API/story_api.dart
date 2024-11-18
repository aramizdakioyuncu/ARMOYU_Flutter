import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class StoryAPI {
  final User currentUser;
  StoryAPI({required this.currentUser});

  Future<Map<String, dynamic>> stories({
    required int page,
  }) async {
    return await API.service.storyServices.stories(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> addstory({
    required String imageURL,
    required bool isEveryonePublish,
  }) async {
    return await API.service.storyServices.addstory(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      imageURL: imageURL,
      isEveryonePublish: isEveryonePublish,
    );
  }

  Future<Map<String, dynamic>> removestory({
    required int storyID,
  }) async {
    return await API.service.storyServices.removestory(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }

  Future<Map<String, dynamic>> hidestory({
    required int storyID,
  }) async {
    return await API.service.storyServices.hidestory(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }

  Future<Map<String, dynamic>> view({
    required int storyID,
  }) async {
    return await API.service.storyServices.view(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }

  Future<Map<String, dynamic>> fetchviewlist({
    required int storyID,
  }) async {
    return await API.service.storyServices.fetchviewlist(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }

  Future<Map<String, dynamic>> like({
    required int storyID,
  }) async {
    return await API.service.storyServices.like(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }

  Future<Map<String, dynamic>> likeremove({
    required int storyID,
  }) async {
    return await API.service.storyServices.likeremove(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }

  Future<Map<String, dynamic>> likerslist({
    required int storyID,
  }) async {
    return await API.service.storyServices.likerslist(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      storyID: storyID,
    );
  }
}
