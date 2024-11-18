import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class NewsAPI {
  final User currentUser;
  NewsAPI({required this.currentUser});

  Future<Map<String, dynamic>> fetch({
    required int page,
  }) async {
    return await API.service.newsServices.fetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> fetchnews({
    required int newsID,
  }) async {
    return await API.service.newsServices.fetchnews(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      newsID: newsID,
    );
  }
}
