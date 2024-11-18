import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class SearchAPI {
  final User currentUser;
  SearchAPI({required this.currentUser});

  Future<Map<String, dynamic>> hashtag({
    required String hashtag,
    required int page,
  }) async {
    return await API.service.searchServices.hashtag(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      hashtag: hashtag,
      page: page,
    );
  }

  Future<Map<String, dynamic>> searchengine({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.searchengine(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      searchword: searchword,
      page: page,
    );
  }

  Future<Map<String, dynamic>> onlyusers({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.onlyusers(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      searchword: searchword,
      page: page,
    );
  }

  Future<Map<String, dynamic>> onlyschools({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.onlyschools(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      searchword: searchword,
      page: page,
    );
  }

  Future<Map<String, dynamic>> onlyworks({
    required String searchword,
    required int page,
  }) async {
    return await API.service.searchServices.onlyworks(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      searchword: searchword,
      page: page,
    );
  }
}
