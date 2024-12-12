import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:image_picker/image_picker.dart';

class MediaAPI {
  final User currentUser;
  MediaAPI({required this.currentUser});

  //////////////////////MEDIA////////////////////

  Future<MediaFetchResponse> fetch({
    required int uyeID,
    required String category,
    required int page,
  }) async {
    return await API.service.mediaServices.fetch(
      uyeID: uyeID,
      category: category,
      page: page,
    );
  }

  Future<MediaRotationResponse> rotation(
      {required int mediaID, required double rotate}) async {
    return await API.service.mediaServices.rotation(
      mediaID: mediaID,
      rotate: rotate,
    );
  }

  Future<MediaDeleteResponse> delete({required int mediaID}) async {
    return await API.service.mediaServices.delete(mediaID: mediaID);
  }

  Future<MediaUploadResponse> upload({
    required List<XFile> files,
    required String category,
  }) async {
    return await API.service.mediaServices.upload(
      files: files,
      category: category,
    );
  }
}
