import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class NewsAPI {
  final User currentUser;
  NewsAPI({required this.currentUser});

  Future<NewsListResponse> fetch({required int page}) async {
    return await API.service.newsServices.fetch(page: page);
  }

  Future<NewsFetchResponse> fetchnews({required int newsID}) async {
    return await API.service.newsServices.fetchnews(newsID: newsID);
  }
}
