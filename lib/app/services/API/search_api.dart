import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

class SearchAPI {
  final User currentUser;
  SearchAPI({required this.currentUser});

  Future<SearchHashtagListResponse> hashtag({
    required String hashtag,
    required int page,
  }) async {
    return await API.service.searchServices.hashtag(
      hashtag: hashtag,
      page: page,
    );
  }

  Future<SearchListResponse> searchengine({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.searchengine(
      searchword: searchword,
      page: page,
    );
  }

  Future<SearchListResponse> onlyusers({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.onlyusers(
      searchword: searchword,
      page: page,
    );
  }

  Future<ServiceResult> onlyschools({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.onlyschools(
      searchword: searchword,
      page: page,
    );
  }

  Future<ServiceResult> onlyworks({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.onlyworks(
      searchword: searchword,
      page: page,
    );
  }
}
