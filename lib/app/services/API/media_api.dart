import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:image_picker/image_picker.dart';

class MediaAPI {
  final User currentUser;
  MediaAPI({required this.currentUser});

  //////////////////////MEDIA////////////////////

  Future<Map<String, dynamic>> fetch({
    required int uyeID,
    required String category,
    required int page,
  }) async {
    return await API.service.mediaServices.fetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      uyeID: uyeID,
      category: category,
      page: page,
    );
  }

  Future<Map<String, dynamic>> rotation({
    required int mediaID,
    required double rotate,
  }) async {
    return await API.service.mediaServices.rotation(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      mediaID: mediaID,
      rotate: rotate,
    );
  }

  Future<Map<String, dynamic>> delete({
    required int mediaID,
  }) async {
    return await API.service.mediaServices.delete(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      mediaID: mediaID,
    );
  }

  Future<Map<String, dynamic>> upload({
    required List<XFile> files,
    required String category,
  }) async {
    return await API.service.mediaServices.upload(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      files: files,
      category: category,
    );
  }
}
